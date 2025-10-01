import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:async'; //import ini untuk menggunakan timeout

class AuthRepo {
  final String _baseUrl = 'http://192.168.168.6:8280/auth/login';
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'jwt_token'; //kunci untuk secure storage
  static const _refreshToken = 'refresh_token';

  Future<UserModel> login(String username, String password) async {
    try {
      final respons = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type' : 'application/json'},
        body: json.encode({
          'username' : username,
          'password' : password,
        }),
      ).timeout(const Duration(seconds: 10));

      if (respons.statusCode == 200) {
        final userData = json.decode(respons.body);
        final token = userData['token']?.toString() ?? '';
        final refreshToken = userData['refreshToken']?.toString() ?? '';

        if (token.isEmpty || JwtDecoder.isExpired(token)) {
          throw Exception('Token tidak valid atau kedaluwarsa');
        }

        // Dekode token untuk mendapatkan data payload (termasuk 'sub' dan 'role')
        final decodedToken = JwtDecoder.decode(token);
        // Buat objek UserModel dari data yang didekode, bukan dari userData mentah
        final user = UserModel.fromJson({
          'token': token,
          'username': decodedToken['sub'],
          'role': decodedToken['role'],
        });


        await _storage.write(key: _tokenKey, value: token); //simpan token ke secure storage
        if (refreshToken.isNotEmpty) {
          await _storage.write(key: _refreshToken, value: refreshToken);
        }

        return user;
      } else {
        final errorMessage = _parseErrorMessage(respons);
        throw Exception(errorMessage);
      }
    } on TimeoutException catch (_) {
      throw Exception(
          'Permintaan login gagal: Batas waktu habis. Periksa koneksi atau server.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }


  //Auto-login check
  Future<UserModel> cekAutoLogin() async {
    try {
      final token = await readToken();
      if (token == null || token.isEmpty) {
        throw Exception('Tidak ada token tersimpan');
      }

      if (JwtDecoder.isExpired(token)) {
        //nyoba refresh token
        final refresUser = await refreshToken();
        if (refresUser == null) {
          throw Exception('Gagal refresh token');
        }
        return refresUser;
      }

      //token masih valid, buat UserModel
      final decodeToken = JwtDecoder.decode(token);
      return UserModel.fromJson({
        'token' : token,
        'username': decodeToken['sub'],
        'role'  :decodeToken['role'],
      });
    } catch (e) {
      log('Auto login gagal: $e');
      rethrow;
    }
  }


  // Refresh token
  Future<UserModel?> refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: _refreshToken);
      if (refreshToken == null) return null;

      final refreshUrl  = 'http://192.168.219.242:8080/auth/refresh';
      final response = await http.post(
        Uri.parse(refreshUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        final newToken = userData['token']?.toString() ?? '';

        if (newToken.isNotEmpty && !JwtDecoder.isExpired(newToken)) {
          await _storage.write(key: _tokenKey, value: newToken);

          final decodedToken = JwtDecoder.decode(newToken);
          return UserModel.fromJson({
            'token': newToken,
            'username': decodedToken['sub'],
            'role': decodedToken['role'],
          });
        }
      }
      return null;
    } on TimeoutException catch (_) {
      throw Exception('Permintaan refresh token gagal: Batas waktu habis. Periksa koneksi atau server.');
    } catch (e) {
      log('Token refresh failed: $e');
      return null;
    }
  }

  Future<String?> readToken() async {
    return await _storage.read(key: _tokenKey); //baca token
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey); //untuk hapus token dari secure storage saat logout
    await _storage.delete(key: _refreshToken);
  }

  String _parseErrorMessage(http.Response response) {
    if (response.body.isNotEmpty) {
      try {
        final errorData = json.decode(response.body);
        return errorData['message']?.toString() ??
            errorData['error']?.toString() ??
            'Login Gagal: Status ${response.statusCode}';
      } catch (e) {
        return 'Login Gagal: ${response.body}';
      }
    }
    return 'Login Gagal: Respons kosong. Status ${response.statusCode}';
  }
}


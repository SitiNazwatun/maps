import 'dart:convert';
import 'dart:io';
import 'package:maps/repositorie/auth_repo.dart';

import '../model/map_model.dart';
import '../model/tempat.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';



class MapRepo {
  final String _baseUrl = 'http://192.168.168.6:8280/destinations/grouped';
  final AuthRepo _authRepo = AuthRepo(); //supaya bisa ambil token


  //method fetchMapData
  Future<List<MapModel>> fetchMapData(String subkategori) async {
    //kenapa ada subkategori? ini tuh mksdnya dia ambil subkategori dari TempatByKategori
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      //ambil token dari authrepo
      final token = await _authRepo.readToken();
      if (token == null || token.isEmpty) {
        throw Exception("Token tidak ditemukan, silakan login ulang!");
      }

      //panggil API dengan header Authorization
      final respons = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      //cek status respon
      if (respons.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(respons.body);

        // ambil sesuai subkategori (contoh: "Kecantikan")
        final List<dynamic> rawDataList = decoded[subkategori] ?? [];

        return rawDataList.map((json) => MapModel.fromJson(json)).toList();
      } else {
        throw Exception("Gagal ambil data: ${respons.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetchMapData: $e");
    }
  }
}

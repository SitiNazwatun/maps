import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/model.dart';

class ApiService {
  static const String baseUrl = "https://68c1307098c818a69400ec2d.mockapi.io/api/maps/kategori";

  //make static biar gampang dipangil di home, biar ga usah buat objek lagi
  static Future<List<Kategori>> fetchKategori() async {
    try {
      print("Fetching data from: $baseUrl"); // Debug log


      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 10)); // Tambahkan timeout

      print("Response status: ${response.statusCode}"); // Debug log
      print("Response body: ${response.body}"); // Debug log

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((json) => Kategori.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load kategori - Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in fetchKategori: $e");
      throw Exception("Network error: $e");
    }
  }
}
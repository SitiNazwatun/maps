
import 'package:flutter/material.dart';

// File: ../model/map_model.dart (VERSI SEDERHANA UNTUK MAPS PAGE)

class MapModel {
  // Properti yang dibutuhkan di Maps Page dan Detail Card:
  final String subkategori;
  final String id; // Digunakan sebagai ID unik (dari field 'nama')
  final String nama; // Nama tempat (dari field 'nama')
  final String alamat; // Alamat (dari field 'alamat')
  final double lat; // Latitude
  final double lng; // Longitude
  final double rating; // Rating (dari field 'rating')
  final String fotoTempat;
  final String jamOperasi;
  final String kontak;

  // List ini harus menggunakan List<dynamic> atau List<Map<String, dynamic>>
  final List<dynamic>? fotoMenu;
  final List<dynamic>? fasilitas;
  final List<dynamic>? gambar;

  MapModel({
    required this.subkategori,
    required this.id,
    required this.nama,
    required this.alamat,
    required this.lat,
    required this.lng,
    required this.rating,
    required this.fotoTempat,
    required this.jamOperasi,
    required this.kontak,
    this.fotoMenu,
    this.fasilitas,
    this.gambar,
  });

  // Factory constructor untuk membuat objek dari Map JSON/Dummy Data
  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      subkategori: json['subkategori'] ?? '',
      id: json['id'] ?? json['nama'] ?? 'unknown',
      // ID bisa dibuat dari nama jika tidak ada
      nama: json['nama'] ?? 'Nama Tidak Diketahui',
      alamat: json['alamat'] ?? 'Alamat Tidak Diketahui',
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),

      // MAPPING DETAIL
      fotoTempat: json['fotoTempat'] ?? '',
      // Default ke string kosong
      jamOperasi: json['jamOperasi'] ?? 'Tidak Tersedia',
      kontak: json['kontak'] ?? 'Tidak Tersedia',

      // MAPPING LIST (Pastikan tipe data sesuai List<dynamic>)
      fotoMenu: json['fotoMenu'] as List<dynamic>?,
      fasilitas: json['fasilitas'] as List<dynamic>?,
      gambar: json['gambar'] as List<dynamic>?,
    );
  }


// Catatan: Jika Anda ingin menggunakan detail lain di halaman Detail,
// Anda bisa membuat MapModelDetail terpisah atau hanya menambahkannya kembali di sini.
}



// class MapModel {
//   final String type;
//   final String id;
//   final String place;
//   final String title;
//   final double mag;
//   final double lat;
//   final double lng;
//
//
//   MapModel({
//     required this.type,
//     required this.id,
//     required this.place,
//     required this.title,
//     required this.mag,
//     required this.lat,
//     required this.lng,
//   });
//
//   //ini untuk membuat objek MapModel dari JSON
//   factory MapModel.fromJson(Map<String, dynamic> json) {
//     final properties = json['properties'];
//     final coordinates = json['geometry']['coordinates'] ?? [0,0];
//
//     return MapModel(
//       type: json['type'] ?? '',
//       id: json['id'] ?? '',
//       title: properties['title'] ?? '-',
//       place: properties['place'] ?? '-',
//       mag: (properties['mag'] ?? 0).toDouble(),
//       lat: (coordinates[1] as num).toDouble(),
//       lng: (coordinates[0] as num).toDouble(),
//     );
//   }
//
//   /// Skala magnitude (0–10) ke rating (1–5)
//   double get forRating {
//   return (mag / 2).clamp(1.0, 5.0);
//   }
// }
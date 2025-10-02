import 'package:flutter/material.dart';

class MapModel {
  // Properti yang dibutuhkan di Maps Page dan Detail Card:
  final String subkategori;
  final String fotoTempat;
  final String nama; // Nama tempat (dari field 'nama')
  final String alamat; // Alamat (dari field 'alamat')
  final double rating; // Rating (dari field 'rating')
  final String jamOperasi;
  final String kontak;
  final List<dynamic>? fotoMenu;
  final List<dynamic>? fasilitas;
  final List<dynamic>? gambar;
  final double lat; // Latitude
  final double lng; // Longitude

  MapModel({
    required this.subkategori,
    required this.fotoTempat,
    required this.nama,
    required this.alamat,
    required this.rating,
    required this.jamOperasi,
    required this.kontak,
    this.fotoMenu,
    this.fasilitas,
    this.gambar,
    required this.lat,
    required this.lng,
  });

  // Factory constructor untuk membuat objek dari Map JSON/Dummy Data
  factory MapModel.fromJson(Map<String, dynamic> json) {
    return MapModel(
      subkategori: json['subkategori'] ?? '',
      fotoTempat: json['fotoTempat'] ?? '',
      nama: json['nama'] ?? 'Nama Tidak Diketahui',
      alamat: json['alamat'] ?? 'Alamat Tidak Diketahui',
      rating: (json['rating'] as num).toDouble(),
      jamOperasi: json['jamOperasi'] ?? '',
      kontak: json['kontak'] ?? '',
      fotoMenu: List<Map<String, dynamic>>.from(json['fotoMenu'] ?? []),
      fasilitas: List<Map<String, dynamic>>.from(json['fasilitas'] ?? []),
      gambar: List<Map<String, dynamic>>.from(json['gambar'] ?? []),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),

    );
  }
}


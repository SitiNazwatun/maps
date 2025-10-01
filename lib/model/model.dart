import 'package:flutter/material.dart';

class SubKategori {
  final String title;
  final String icon;

  SubKategori({required this.title, required this.icon});

  factory SubKategori.fromJson(Map<String, dynamic> json) {
    return SubKategori(
      title: json['title']?.toString() ?? 'Unknown Title',
      icon: json['icon']?.toString() ?? 'help_outline',
    );
  }
}

class Kategori {
  final String nama;
  final List<SubKategori> subKategori;

  Kategori({required this.nama, required this.subKategori});

  factory Kategori.fromJson(Map<String, dynamic> json) {
    var list = json['subkategori'] as List;
    List<SubKategori> sub = list.map((i) => SubKategori.fromJson(i)).toList();

    return Kategori(
      nama: json['nama']?.toString() ?? 'Unknown Category',
      subKategori: sub,
    );
  }
}
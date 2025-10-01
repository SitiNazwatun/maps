import 'package:flutter/material.dart';

final Map<String, List<Map<String, dynamic>>> menuByKategori = {
  "Makanan & Gaya Hidup": [
    {"icon": Icons.restaurant, "title": "Restoran"},
    {"icon": Icons.local_cafe, "title": "Kafe"},
    {"icon": Icons.shopping_bag, "title": "Pusat Perbelanjaan"},
    {"icon": Icons.fastfood, "title": "Kecantikan"},
  ],
  "Aktivitas & Rekreasi": [
    {"icon": Icons.family_restroom, "title": "Hiburan Keluarga"},
    {"icon": Icons.sports_gymnastics, "title": "Tempat Olahraga"},
    {"icon": Icons.shopping_bag, "title": "Akomodasi"},
    {"icon": Icons.emoji_transportation, "title": "Transportasi"},
  ],
  "Pendidikan": [
    {"icon": Icons.school, "title": "SD"},
    {"icon": Icons.school, "title": "SMP"},
    {"icon": Icons.class_rounded, "title": "SMA"},
    {"icon": Icons.library_books, "title": "Universitas"},
  ],
  "Kesehatan & Keagamaan": [
    {"icon": Icons.local_hospital, "title": "Rumah Sakit"},

    {"icon":Icons.local_pharmacy, "title": "Apotek"},
    {"icon":Icons.mosque, "title": "Tempat Ibadah"},
  ],
};

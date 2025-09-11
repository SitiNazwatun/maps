import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedKategori = "Food & Drink";

  final Map<String, List<Map<String, dynamic>>> menuByKategori = {
    "Food & Drink": [
      {"icon": Icons.restaurant, "title": "Restoran"},
      {"icon": Icons.local_cafe, "title": "Kafe"},
      {"icon": Icons.cake, "title": "Toko Roti"},
      {"icon": Icons.fastfood, "title": "Pusat Makanan"},
    ],
    "Rekreasi & Hiburan": [
      {"icon": Icons.tour, "title": "Tempat Wisata"},
      {"icon": Icons.family_restroom, "title": "Hiburan Keluarga"},
      {"icon": Icons.shopping_bag, "title": "Pusat Perbelanjaan"},
      {"icon": Icons.sports_gymnastics, "title": "Tempat Olahraga"},
    ],
    "Pendidikan": [
      {"icon": Icons.school, "title": "Sekolah"},
        {"icon": Icons.school, "title": "Universitas"},
      {"icon": Icons.class_rounded, "title": "Kursus dan Pelatihan"},
      {"icon": Icons.library_books, "title": "Perpustakaan"},
    ],
    "Kesehatan": [
      {"icon": Icons.local_hospital, "title": "Medis"},
      {"icon":Icons.local_pharmacy, "title": "Apotek"},
      {"icon":Icons.fitness_center, "title": "Pusat Kebugaran"},
    ],
    "Layanan Jasa": [
      {"icon": Icons.directions_car, "title": "Otomotif"},
      {"icon":Icons.face, "title": "Kecantikan"},
      {"icon":Icons.more_horiz, "title": "Layanan Lainnya"},
    ],
    "Transportasi & Akomodasi": [
      {"icon": Icons.emoji_transportation, "title": "Transportasi "},
      {"icon":Icons.hotel, "title": "Akomodasi"},
    ],
    "Pemerintahan & Keagamaan": [
        {"icon": Icons.business_sharp, "title": "Kantor Publik "},
      {"icon":Icons.mosque, "title": "Tempat Ibadah"},
    ],

};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(17, 10, 17, 0), // jarak dari atas,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // bagian text Hello-nya
                    Text(
                      "Hello!",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00016A),
                      ),
                    ),


                    //bagian akun orang
                    ClipOval(
                      child: Image.asset(
                          'galeri/user.png',
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                      ),
                    ),

                    // kalau diambil dari server
                    // CircleAvatar(
                    //   radius: 20,
                    //   backgroundImage: NetworkImage(user.photoUrl), // ambil dari data user
                    //   backgroundColor: Colors.grey[200], // fallback kalau kosong
                    // )

                    //kalau user belum punya foto profil
                    // CircleAvatar(
                    //   radius: 20,
                    //   backgroundColor: Colors.blue,
                    //   child: Text(
                    //     user.name[0].toUpperCase(), // ambil huruf pertama
                    //     style: const TextStyle(color: Colors.white),
                    //   ),
                    // )

                  ],
                ),
              ),


              Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(17, 10, 17, 0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, // warna border
                                    width: 0.8,         // tebal border
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15), // warna bayangan
                                      blurRadius: 6,  // atur tingkat blur
                                      offset: const Offset(0, 3), // arah bayangan (x, y)
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search",
                                    prefixIcon: Icon(Icons.search),
                                    contentPadding: EdgeInsets.symmetric(vertical: 12), //buat atur tulisan search supaya nggak ikutin tinggi icon
                                  ),
                                ),
                              ),
                      const SizedBox(height: 24),
                    ]
                  )
                ),

                Image.asset(
                    "galeri/card3.png", //
                    height: 225,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 24),


              Padding(
                padding: const EdgeInsets.fromLTRB(17, 10, 17, 0),
                child: Column(
                  children: [
                    // kategori (chips)
                          SizedBox(
                            height: 40,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: menuByKategori.keys.map((category) {
                                return _buildCategoryChip(
                                  category,
                                  selectedKategori == category,
                                      () {
                                    setState(() => selectedKategori = category);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Grid subkategori berdasarkan kategori terpilih
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 17,
                            crossAxisSpacing: 17,
                            childAspectRatio: 1.2,
                            children: menuByKategori[selectedKategori]!
                                .map((menu) =>
                                _buildKategoriCard(menu["icon"], menu["title"]))
                                .toList(),
                          ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  // helper kategori onTap
  Widget _buildCategoryChip(
      String label, bool selected, VoidCallback onTap) {
      return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Color(0xFF00016A) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey, // warna border
            width: 0.8,         // tebal border
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            // fontSize: 11,
          ),
        ),
      ),
    );
  }

  // helper kartu sub-kategori
  Widget _buildKategoriCard(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // warna bayangan
            blurRadius: 6,  // atur tingkat blur
            offset: const Offset(0, 3), // arah bayangan (x, y)
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Color(0xFF00016A)),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Color(0xFF00016A),
              // fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

}





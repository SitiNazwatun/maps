import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:maps/maps.dart';
import 'model/kategori.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedKategori = "Makanan & Gaya Hidup";

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
                    PopupMenuButton <String>(
                      offset: const Offset(0, 60),
                      color: const Color(0xFF00016A), // warna background popup
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // sudut membulat
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 50,   // lebar minimum popup
                      ),
                      onSelected: (value) {
                        if (value == 'Logout') {
                          //enih aksinya
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                    "Konfirmasi",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color(0xFF00016A),
                                ),
                                ),
                                content: Text(
                                    "Anda yakin akan logout?",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Color(0xFF00016A),
                                ),
                                ),
                                actions:  [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child:  Text(
                                          "Batal",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Color(0xFF00016A),
                                      ),
                                  ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); //nutup dialog
                                        // Navigator.pushReplacementNamed(context, /login), //hapus session, token, lalu redirect ke login
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const LoginPage()
                                          ),
                                        );
                                      },
                                      child: Text(
                                          "Logout",
                                              style: GoogleFonts.poppins(
                                              fontSize: 15,
                                                color: Color(0xFF00016A),
                                      ),
                                      ),
                                  ),
                                ],
                              ),
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'Logout',
                          child: Center(
                          child: Text(
                              "Logout",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white, // atur teks di pop-up enih
                              ),
                          ),
                        ),
                        ),
                      ],
                      child: ClipOval(
                        child: Image.asset(
                            'galeri/user.png',
                            width: 54,
                            height: 54,
                            fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // ClipOval(
                    //   child: Image.asset(
                    //       'galeri/user.png',
                    //       width: 54,
                    //       height: 54,
                    //       fit: BoxFit.cover,
                    //   ),
                    // ),

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
              const SizedBox(height: 12),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17), // padding kiri kanan 17 untuk container
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,   // ubah jadi full width
                      height: 45,   // tinggi box
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8), // padding dalam container
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center, // biar teksnya center
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 40, // kasih ruang buat icon biar ga kejepit
                              minHeight: 40,
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 0), // biar teks pas tengah
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),


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
                              children: menuByKategori.keys.map((kategori) {
                                return _buildCategoryChip(
                                  kategori,
                                  selectedKategori == kategori,
                                      () {
                                    setState(() => selectedKategori = kategori);
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
                                .map((subkategori) =>
                                _buildKategoriCard(subkategori["icon"], subkategori["title"]))
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
          // border: Border.all(
          //   color: Colors.grey, // warna border
          //   width: 0.8,         // tebal border
          // ),
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
    return InkWell(
        onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapsPage(subkategori: title), // enih buat kirim judul
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(
        //   color: Colors.grey,
        //   width: 0.8,
        // ),
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
    ),
    );
  }

}





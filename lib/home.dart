import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; //ubah data, ini di import karena mau ambil data dari API
import '../model/model.dart';
import 'api/api.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Kategori> kategoriList = []; //buat nyimpen kategori dari API
  String selectedKategori = ""; //buat simpen kategori yang lagi dipilih ama user
  bool isLoading = true; //ini buat status loading
  String errorMessage = ""; //ini buat pesan error

  @override
  void initState() {
    super.initState();
    loadKategori(); //ini nanti langsung manggil ini dari API
  }

  Future<void> loadKategori() async {
    setState(() {
      isLoading = true; //manggil dan nampilin si isLoading
      errorMessage = ""; //ini hapus pesan error biar clean dulu
    });

    try { //ini bagian percobaan biar kalo ada error bisa ditangkep catch
      final data = await ApiService.fetchKategori();
      setState(() {
        kategoriList = data; //ini nyimpen data kategori ke variabel
        selectedKategori = data.isNotEmpty ? data[0].nama : ""; //kalau nggak 0 isi kategori 1 sebagai default, kalo 0 mah isi kosong aja
        isLoading = false; //proses selesai, jadi matiin loading jadi false
      });
    } catch (e) {
      print("Error fetch kategori: $e"); //menampilkan error di console
      setState(() {
        errorMessage = "Gagal memuat data: $e"; //ini simpen pesan supaya bisa di tampilin di UI
        isLoading = false; //matiin loading meski error
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      body: SafeArea( //isLoading -> error -> konten utama
        child: isLoading
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Memuat data..."),
            ],
          ),
        )
            : errorMessage.isNotEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(errorMessage, textAlign: TextAlign.center),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: loadKategori,
                child: Text("Coba Lagi"),
              ),
            ],
          ),
        )
            : SingleChildScrollView(  //supaya bisa scrool sepenuhnyaaaa
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //bagian atas
              Padding(
                padding: const EdgeInsets.fromLTRB(17, 10, 17, 0),
                child: Row( //make row soalnya ada yg di kanan dan kiri
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, //spaceBeetween enih biar keduanya renggang...waduh asing kah?
                  children: [
                    Text(
                      "Hello!",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00016A),
                      ),
                    ),
                    ClipOval(
                      child: Image.asset(
                        'galeri/user.png',
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover, //enih mastiin supaya si gambar memenuhi space yg dikasih
                      ),
                    ),
                  ],
                ),
              ),

              // bagian search
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(17, 10, 17, 0), //enih atur dari mulai kiri, atas, kanan, bawah. biar adil hehehe
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
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
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

              // card
              Image.asset(
                "galeri/card3.png",
                height: 225,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 24),

              // kategori
              if (kategoriList.isNotEmpty) //ini mksdnya bakal tampil kalo ada data yeah
                Padding(
                  padding: const EdgeInsets.fromLTRB(17, 10, 17, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: kategoriList.map((category) { //ini ngelooping tiap item kategoriList yg dari API
                            return _buildCategoryChip( //manggil ini buat bikin tombol kategori di UI
                              category.nama, //nama kategori buat tombol kecil itu
                              selectedKategori == category.nama,
                                  () {
                                setState(() => selectedKategori = category.nama); //aksi pas tombol di klik
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // subkategori
                      Builder(builder: (context) {
                        try {
                          final selected = kategoriList.firstWhere(
                                (k) => k.nama == selectedKategori,
                          );
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(), //men-nonaktifkan scrooling gridvoiew ajah supaya ttp keseluruhan halaman yg di scrool
                            crossAxisCount: 2, //ini atur ada berapa kolom
                            mainAxisSpacing: 17, //atur jarak antar item nih
                            crossAxisSpacing: 17, //
                            childAspectRatio: 1.2, //atur rasio lebar:tinggi tiap item yeah
                            children: selected.subKategori
                                .map((sub) => _buildKategoriCard( //ini biar dia make _buildKategoriCard
                                getIconFromString(sub.icon), sub.title)) //ini biar dia make getIconFromString
                                .toList(),
                          );
                        } catch (e) {
                          return Text("Error loading subcategories");
                        }
                      }),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Color(0xFF00016A) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey, width: 0.8),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildKategoriCard(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
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
            ),
          ),
        ],
      ),
    );
  }

  // helper buat ubah string icon menjadi IconData Flutter
  IconData getIconFromString(String name) {
    // ini buat print nama icon yang diterima
    print("Icon name from API: '$name'");

    // nah, di JSON tuh ada Icons.restaurant, jadi dihapus aja Iconsnya
    String iconName = name.replaceAll('Icons.', '');
    // nah ini print iconName yang mana tadi ini untuk identitas hapus Icons-nya
    print("🧹 Cleaned icon name: '$iconName'");

    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'local_cafe':
        return Icons.local_cafe;
      case 'cake':
        return Icons.cake;
      case 'fastfood':
        return Icons.fastfood;
      case 'tour':
        return Icons.tour;
      case 'family_restroom':
        return Icons.family_restroom;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'sports_gymnastics':
        return Icons.sports_gymnastics;
      case 'school':
        return Icons.school;
      case 'class_rounded':
        return Icons.class_rounded;
      case 'library_books':
        return Icons.library_books;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'local_pharmacy':
        return Icons.local_pharmacy;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'directions_car':
        return Icons.directions_car;
      case 'face':
        return Icons.face;
      case 'more_horiz':
        return Icons.more_horiz;
      case 'emoji_transportation':
        return Icons.emoji_transportation;
      case 'hotel':
        return Icons.hotel;
      case 'business_sharp':
        return Icons.business_sharp;
      case 'mosque':
        return Icons.mosque;
      default: //ini misal icon yang mau ditarik kaga ada di API, nah bakal nampilin default ini nih
        print("❌ Icon not found: '$iconName', using help_outline");
        return Icons.help_outline;
    }
  }



}
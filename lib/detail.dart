  import 'package:flutter/material.dart';
  // import 'package:maps/model/tempat.dart';
  import '../model/tempat.dart';
  import 'package:maps/detail.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'maps.dart';


  class DetailPage extends StatefulWidget {
    final Map<String, dynamic> item;
    //item dari mana? itu parameter dari maps.dart saat marker di klik

    const DetailPage({super.key, required this.item});



    @override
    State<DetailPage> createState() => _DetailPageState();
  }

  class _DetailPageState extends State<DetailPage> {
    late Map<String, dynamic> SelectDetail;

    @override
    void initState() {
      super.initState();
      SelectDetail = widget.item; //variabel untuk data dari widget item supaya dapat digunakan oleh halaman enih
    }

    // Helper  untuk icon
    Widget _buildCustomIcon(IconData iconData) {
      return Icon(
        iconData,
        size: 24,
        color: const Color(0xFF00016A),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        SelectDetail["fotoTempat"],
                        // "galeri/ayamgulai.jpeg",
                        width: double.infinity,
                        height: 325,
                        fit: BoxFit.cover,
                      ),

                      //tombol kembali
                      Positioned(
                        top: 40,
                        left: 17,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),

                    ],
                  ),


                  Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //nama dan alamat
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      SelectDetail['nama'] ?? "Nama Tidak Ditemukan",
                                      style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      SelectDetail['alamat'] ?? "Alamat Tidak Ditemukan",
                                      style: GoogleFonts.poppins(fontSize: 15),
                                    ),
                                  ],
                                )
                            ),
                            const SizedBox(height: 20),

                            //tombol rute
                            ClipOval(
                              child: Material(
                                color: Colors.green,
                                child: InkWell(
                                  onTap: () { //ini buat pindah halaman ke maps lalu munculin rute
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MapsPage(
                                          subkategori: SelectDetail['subkategori'],
                                          tujuanLat: SelectDetail['lat'], //ambil koordinat titik saat ini yg dipilih, terus nanti konek ama maps dan munculin rute
                                          tujuanLng: SelectDetail['lng'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Icon(
                                        Icons.directions,
                                        color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),


                        //TENTANG
                        Container(
                          width: 120,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF00016A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Tentang",
                            style: GoogleFonts.poppins( color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                            ),
                          ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            _buildCustomIcon(Icons.access_time),                            SizedBox(width: 8),
                            Text(
                              SelectDetail['jamOperasi'] ?? "Nama Tidak Ditemukan",
                              style: GoogleFonts.poppins(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            _buildCustomIcon(Icons.phone_in_talk_outlined),
                            SizedBox(width: 8),
                            Text(
                              SelectDetail['kontak'] ?? "Kontak Tidak Ditemukan",
                              style: GoogleFonts.poppins(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        //MENU
                      if (SelectDetail['fotoMenu'] != null && (SelectDetail['fotoMenu'] as List).isNotEmpty) ...[
                        Container(
                          width: 120,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF00016A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Menu",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          crossAxisCount: 2,
                          mainAxisSpacing: 17,
                          crossAxisSpacing: 17,
                          childAspectRatio: 1,
                          children: (SelectDetail["fotoMenu"] as List)
                            .map((menu) => _buildMenuCard(
                              menu["gambarMenu"],
                              menu["namaMenu"] ?? "Menu Tidak Tersedia",
                          ))
                              .toList(),
                        ),
                      ],
                        const SizedBox(height: 20),

                        //FASILITAS
                        if (SelectDetail['fasilitas'] != null && (SelectDetail['fasilitas'] as List).isNotEmpty) ...[
                        Container(
                          width: 120,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF00016A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child:  Text(
                            "Fasilitas",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),


                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17),
                          child: _buildFasilitasFromData(),
                        ),
                        SizedBox(height: 20),

                        //GAMBAR
                        if (SelectDetail['gambar'] != null && (SelectDetail['gambar'] as List).isNotEmpty) ...[
                        Container(
                          width: 120,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF00016A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Gambar",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        ],
                        const SizedBox(height: 10),

                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          crossAxisCount: 2,
                          mainAxisSpacing: 17,
                          crossAxisSpacing: 17,
                          childAspectRatio: 1,
                          children: (SelectDetail["gambar"] as List)
                              .map((gambar) => _buildGambar(
                            (gambar as Map<String, dynamic>)["gambar"],
                          ))
                              .toList(),
                        ),
                        ],
                        const SizedBox(height: 20),

                      ],
                    ),
                  )
                ],
              )
          ),
      );
    }


    Widget _buildMenuCard(String gambar, String nama) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded( // gambar memenuhi ruang
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    gambar,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                nama,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildGambar(String gambarUrl) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15), // buat sudut melengkung, bisa dihapus kalau mau kotak
        child: Image.asset(
          gambarUrl,
          fit: BoxFit.cover, // supaya memenuhi kotak grid
        ),
      );
    }

    // Widget untuk membangun fasilitas dari data
    Widget _buildFasilitasFromData() {
      List<Map<String, dynamic>> fasilitas = List<Map<String, dynamic>>.from(SelectDetail['fasilitas'] ?? []);

      // Bagi fasilitas menjadi 2 kolom
      List<Widget> leftColumn = [];
      List<Widget> rightColumn = [];

      for (int i = 0; i < fasilitas.length; i++) {
        Widget fasilitasItem = Row(
          children: [
            Icon(fasilitas[i]['icon'] ?? Icons.help, size: 18, color: Color(0xFF00016A)),
            SizedBox(width: 5),
            Expanded(child: Text(fasilitas[i]['namafas'] ?? "Fasilitas",
            style: GoogleFonts.poppins(
              fontSize: 15
            ),
            )),
          ],
        );

        if (i % 2 == 0) {
          leftColumn.add(fasilitasItem);
          if (i < fasilitas.length - 1) leftColumn.add(SizedBox(height: 10));
        } else {
          rightColumn.add(fasilitasItem);
          if (i < fasilitas.length - 1) rightColumn.add(SizedBox(height: 10));
        }
      }

      // PERBAIKAN: Tambahkan return statement
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: leftColumn,
            ),
          ),
          SizedBox(width: 20),
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rightColumn,
            ),
          ),
        ],
      );
    }

  }



import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  final List<Map<String, String>> menuMakanan = [
    {
      "nama": "Nasi Gulai",
      "gambar": "galeri/nasigulai.jpeg",
    },
    {
      "nama": "Nasi Ayam Gulai",
      "gambar": "galeri/ayamgulai.jpeg",
    },
    {
      "nama": "Nasi Rendang",
      "gambar": "galeri/nasigulai.jpeg",
    },
    {
      "nama": "Nasi Kikil",
      "gambar": "galeri/ayamgulai.jpeg",
    },
  ];

  final List<Map<String, String>> Gambar = [
    {
      "gambar": "galeri/nasigulai.jpeg",
    },
    {
      "gambar": "galeri/ayamgulai.jpeg",
    },
    {
      "gambar": "galeri/nasigulai.jpeg",
    },
    {
      "gambar": "galeri/ayamgulai.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                        "galeri/padang2.jpeg",
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
                      Text(
                        "Rumah Makan Padang",
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Jl. Kebon Jati No. 45 Kelurahan Sukajadi, Kecamatan Cihampelas Kota Bandung, Jawa Barat 40156",
                        style: TextStyle(fontSize: 12),
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
                        child: const Text(
                          "Tentang",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Icon(Icons.access_time, size: 20, color: Colors.black87),
                          SizedBox(width: 8),
                          Text(
                            "9.00 AM – 8.30 PM",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.phone_in_talk_outlined, size: 20, color: Colors.black87),
                          SizedBox(width: 8),
                          Text(
                            "0812-3456-7890",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      //MENU
                      Container(
                        width: 120,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFF00016A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Menu",
                          style: TextStyle(
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
                        children: menuMakanan
                            .map((menu) => _buildMenuCard(menu["gambar"]!, menu["nama"]!))
                            .toList(),
                      ),
                      const SizedBox(height: 20),

                      //FASILITAS
                      Container(
                        width: 120,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFF00016A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Fasilitas",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child:
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible (flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Row(
                                      children: [
                                        Icon(Icons.wifi, size: 18, color: Color(0xFF00016A)),
                                        SizedBox(width: 5),
                                        Text("Wifi Gratis"),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.local_parking, size: 18, color: Color(0xFF00016A)),
                                        SizedBox(width: 5),
                                        Text("Area Parkir"),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.ac_unit, size: 18, color: Color(0xFF00016A)),
                                        SizedBox(width: 5),
                                        Text("AC"),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                            Flexible(flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Row(
                                    children: [
                                      Icon(Icons.restaurant_menu, size: 18, color: Color(0xFF00016A)),
                                      SizedBox(width: 5),
                                      Text("Prasmanan"),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.room_preferences_outlined, size: 18, color: Color(0xFF00016A)),
                                      SizedBox(width: 5),
                                      Text("Ruang Nyaman"),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                            // Flexible( flex: 3,
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: const [
                            //         Row(
                            //           children: [
                            //             Icon(Icons.local_parking, size: 18, color: Color(0xFF00016A)),
                            //             SizedBox(width: 2),
                            //             Text("Area Parkir"),
                            //           ],
                            //         ),
                            //         SizedBox(height: 10),
                            //         Row(
                            //           children: [
                            //             Icon(Icons.ac_unit, size: 18, color: Color(0xFF00016A)),
                            //             SizedBox(width: 2),
                            //             Text("AC"),
                            //           ],
                            //         ),
                            //         SizedBox(height: 10),
                            //         Row(
                            //           children: [
                            //             Icon(Icons.restaurant_menu, size: 18, color: Color(0xFF00016A)),
                            //             SizedBox(width: 2),
                            //             Text("Prasmanan"),
                            //           ],
                            //         ),
                            //       ],
                            //     )
                            // )
                          ],
                        )
                      ),
                      SizedBox(height: 20),

                      //GAMBAR
                      Container(
                        width: 120,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFF00016A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Gambar",
                          style: TextStyle(
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
                        children: Gambar
                            .map((menu) => _buildGambar(menu["gambar"]!))
                            .toList(),
                      ),
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


}


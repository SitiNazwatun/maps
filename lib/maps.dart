import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // package untuk koordinat
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps/beranda.dart';
import 'package:maps/detail.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/tempat.dart';


class MapsPage extends StatefulWidget {
  final String subkategori; //ini nyambung aman beranda supaya kalo subkategori di klik masup ke maps terus dengan nama title sesuai yg diklik
  const MapsPage({super.key, required this.subkategori});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final MapController _mapController = MapController();
  LatLng? _userLocation; // posisi user
  late List<Place> placesToShow;


  @override
  void initState() {
    super.initState();
    _getUserLocation();
    //ini ambil data sesuai subkategori
    placesToShow = placesByCategory[widget.subkategori] ?? [];
  }

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude); //ini buat objek koordinat dari posisi user
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        fit: StackFit.expand,
        children: [
          //maps
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation!,
              initialZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _userLocation!,
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_history,
                      color: Color(0xFF00016A),
                      size: 40,
                    ),
                  ),
                  ...placesToShow.map((place) => Marker(
                    point: LatLng(place.lat, place.lng),
                    width: 60,
                    height: 60,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  )),
                ],
              ), // <<< PENTING: koma ini
            ],
          ),

          //bagian atas
          Positioned(
              top: 50,
              left: 17,
              right: 17,
              child: Row(
                children: [
                  Container(
                    height: 50, // samain dengan tinggi search
                    width: 50,  // biar kotak, bukan gepeng
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2), // biar ada bayangan lembut
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      color: Colors.white,
                      // onPressed: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const HomePage(), // ganti ke halaman tujuanmu
                      //     ),
                      //   );
                      // },
                      onPressed: () {
                        Navigator.pop(context); // kembali ke halaman sebelumnya
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Search
                  Expanded(
                    child: Container(
                      height: 50, // samain tingginya
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: widget.subkategori,
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ),

          //bagian bawah
          Positioned(
              left:17,
              right:17,
              bottom: 40,
              child:Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Text(
                          'Rumah Makan Padang',
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                            'Jl. Kebon Jati No. 45 Kelurahan Sukajadi, Kecamatan Cihampelas Kota Bandung, Jawa Barat 40156',
                        style: GoogleFonts.poppins(fontSize: 10),),
                        const SizedBox(height: 8),

                      Row(
                        children: List.generate(5, (index) {
                          return const Icon(Icons.star, color: Colors.orange, size: 20);
                        }),
                      ),
                      const SizedBox(height: 8),

                        Row(
                          children: [
                            //tombol lihat
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF00016A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DetailPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Lihat',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Tombol Rute
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green, // warna beda biar jelas
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: () {
                                  // contoh buka Google Maps dengan koordinat
                                  // final lat = _userLocation?.latitude ?? 0.0;
                                  // final lng = _userLocation?.longitude ?? 0.0;
                                  // final url = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=$lat,$lng");
                                  // launchUrl(url, mode: LaunchMode.externalApplication);
                                },
                                child: const Text(
                                  'Rute',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                ),
              ),
          ),
        ],
      ),
    );
  }
}

// // Halaman selanjutnya
// class NextPage extends StatelessWidget {
//   const NextPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Detail Tempat')),
//       body: const Center(child: Text('Ini halaman detail tempat')),
//     );
//   }
// }
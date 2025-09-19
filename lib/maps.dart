import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'beranda.dart';
import 'package:maps/detail.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/tempat.dart';

class MapsPage extends StatefulWidget {
  final String subkategori;
  final double? tujuanLat; // latitude tujuan untuk nerima lokasi dari hal.detail
  final double? tujuanLng; // longitude tujuan untuk nerima lokasi dari hal.detail


  const MapsPage({
    super.key,
    required this.subkategori,
    this.tujuanLat,
    this.tujuanLng,

  });

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  LatLng? _userLocation; //variabel menyimpan lokasi terkini user
  List<LatLng> _routePoints = []; //menyimpan titik koordinat yang bentuk garis rute
  late List<Map<String, dynamic>> tempatlihat; //list tempat yang akan ditampilkan di peta dari tempat.dart
  Map<String, dynamic>? selectedTempat; // Untuk menyimpan data tempat yang sedang dipilih


  @override
  void initState() {
    super.initState();
    _getUserLocation(); //manggil fungsi minta dan dapatin lokasi pengguna

    // Ambil data sesuai subkategori dari tempat.dart
    tempatlihat = (TempatByKategori[widget.subkategori] ?? []).toList();
    selectedTempat = null; //ini buat mastiin ga ada tempat yg terpilih secara default pas pertama kali di jalanin
  }

  //fungsi untuk mendapatkan lokasi user saat ini dan manggil getRoute
  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission(); //ini minta izin lokasi ke pengguna

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition( //ambil posisi
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude); //fungsi buat naro si marker di lokasi user
      });

      // Jika di klik dari DetailPage, langsung panggil rute
      if (widget.tujuanLat != null && widget.tujuanLng != null) {
        // Cari tempat yang sesuai dengan tujuan yang dikirim dari DetailPage
        final targetTempat = tempatlihat.firstWhere(
            (tempat) => tempat["lat"] == widget.tujuanLat && tempat["lng"] == widget.tujuanLng,
            orElse: () => {},
        );
        //ini atur selectedTempat supaya cardnya muncul
        setState(() {
          if (targetTempat.isNotEmpty) {
            selectedTempat = targetTempat;
          }
        });
        _getRoute( //manggil ini buat gamabar rute ke tempat yg dituju
          _userLocation!,
          LatLng(widget.tujuanLat!, widget.tujuanLng!),
        );
      }
    }
  }



  // Fungsi saat pengguna klik pada marker
  //item nama variabel -> bisa diganti apa aja
  void _onMarkerTapped(item) {
    setState(() {
      selectedTempat = item;
    });

    // Pindahkan map ke lokasi yang dipilih
    _animatedMapMove(LatLng(item['lat'], item['lng']), 18.0); //ini buat atur seberapa jauh zoom in kalau titik lokasi di pilih
  }


  //fungsi animasi buat atur zoom in out pas di klik salah satu titik
  void _animatedMapMove(LatLng dest, double zoom) {
    final camera = _mapController.camera;
    final latTween = Tween<double>(begin: camera.center.latitude, end: dest.latitude);
    final lngTween = Tween<double>(begin: camera.center.longitude, end: dest.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: zoom);

    var controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    controller.forward();
  }



  // Fungsi untuk rute
  Future<void> _getRoute(LatLng from, LatLng to) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/${from.longitude},${from.latitude};${to.longitude},${to.latitude}?overview=full&geometries=geojson',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coords = data['routes'][0]['geometry']['coordinates'] as List;

      setState(() {
        _routePoints = coords
            .map((c) => LatLng(c[1], c[0])) // [lon, lat] → (lat, lon)
            .toList();
      });

      _zoomoutrute();
    }
  }

  //fungsi buat kalo di klik tombol rute jadi auto zoom out gtu
  void _zoomoutrute() {
    if (_routePoints.isEmpty) return;

    // cari batas koordinat (paling utara, selatan, timur, barat)
    var bounds = LatLngBounds.fromPoints(_routePoints);

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50), // jarak dari pinggir layar
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        fit: StackFit.expand,
        children: [
          // Maps
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation!,
              initialZoom: 18, //ini untuk jangkauan mapsnya mau seginimana
              keepAlive: true, // biar posisi map nggak reset tiap setState
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  // Marker untuk lokasi user
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
                  // Marker untuk tempat-tempat
                  ...tempatlihat.map((place) => Marker(
                    point: LatLng(place['lat'], place['lng']),
                    width: 80,
                    height: 80,
                    child: GestureDetector( //widget untuk mendeteksi interaksi user
                      onTap: () => _onMarkerTapped(place),
                      child: Icon(
                        Icons.location_on,
                        color: selectedTempat?['nama'] == place['nama']
                            ? Colors.red
                            : Colors.redAccent,
                        size: selectedTempat?['nama'] == place['nama'] ? 45 : 40,
                      ),
                    ),
                  )),
                ],
              ),
              if (_routePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    color: Colors.blue,
                    strokeWidth: 4,
                  ),
                ],
              ),
            ],
          ),

          // Bagian atas (Search bar dan back button)
          Positioned(
            top: 50,
            left: 17,
            right: 17,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
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
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // Search
                Expanded(
                  child: Container(
                    height: 50,
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
                        hintText: '${widget.subkategori}',
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

          // Bagian bawah (Detail card)
          if (selectedTempat != null)
            Positioned(
              left: 17,
              right: 17,
              bottom: 40,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header dengan navigasi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedTempat!['nama'],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Alamat
                      if (selectedTempat!['alamat'] != null) ...[
                        Text(
                          selectedTempat!['alamat']!,
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Rating
                      if (selectedTempat!['rating'] != null) ...[
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                Icons.star,
                                color: index < (selectedTempat!['rating']!.round())
                                    ? Colors.orange
                                    : Colors.grey[300],
                                size: 16,
                              );
                            }),
                            const SizedBox(width: 8),
                            Text(
                              selectedTempat!['rating']!.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Action buttons
                      Row(
                        children: [
                          // Tombol Lihat Detail
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00016A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(item: selectedTempat!),
                                  ),
                                );
                              },
                              child: Text(
                                'Lihat Detail',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Tombol Rute
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () { //ini action pas di klik maps yg munculin garis rute
                                if (_userLocation != null && selectedTempat != null) {
                                  _getRoute(_userLocation!, LatLng(selectedTempat!['lat'], selectedTempat!['lng']));
                                }
                              },
                              child: Text(
                                'Rute',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Floating Action Button untuk kembali ke lokasi user
          Positioned(
            bottom: selectedTempat != null ? 200 : 100,
            right: 17,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                if (_userLocation != null) {
                  _mapController.move(_userLocation!, 15.0);
                }
              },
              child: const Icon(
                Icons.my_location,
                color: Color(0xFF00016A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
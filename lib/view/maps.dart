import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'beranda.dart';
import 'detail.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/map_model.dart';
import '../bloc/map/map_bloc.dart';
import '../bloc/map/map_state.dart';
import '../bloc/map/map_event.dart';

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
  MapModel? selectedTempat; // Untuk menyimpan data tempat yang sedang dipilih

// Ini untuk menyimpan tujuan yang dikirim dari DetailPage, agar tidak hilang
  double? _initialTujuanLat;
  double? _initialTujuanLng;
  // Helper function untuk membandingkan double dengan toleransi
  bool _areDoublesClose(double a, double b, [double tolerance = 0.000001]) {
    return (a - b).abs() < tolerance;
  }

  @override
  void initState() {
    super.initState();

    // Simpan tujuan awal dari widget ke state lokal
    _initialTujuanLat = widget.tujuanLat;
    _initialTujuanLng = widget.tujuanLng;

    _getUserLocation(); //manggil fungsi minta dan dapatin lokasi pengguna

    selectedTempat = null; //ini buat mastiin ga ada tempat yg terpilih secara default pas pertama kali di jalanin

    // Tambahkan pemanggilan event pertama untuk memuat data peta
    // Menggunakan WidgetsBinding.instance.addPostFrameCallback memastikan context tersedia
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ambil BLoC menggunakan context dan kirim event FetchData
      context.read<MapBloc>().add(FetchData(subkategori: widget.subkategori));
    });
  }

  // Fungsi untuk membersihkan tujuan setelah diproses
  void _clearInitialDestination() {
    _initialTujuanLat = null;
    _initialTujuanLng = null;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
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

      // FIX TIMING: Jika lokasi user sudah ditemukan dan ada tujuan awal,
      // panggil _handleInitialRoute secara eksplisit jika data peta sudah dimuat (MapLoaded).
      if (_initialTujuanLat != null && _initialTujuanLng != null) {
        final currentState = context.read<MapBloc>().state;
        if (currentState is MapLoaded) {
          _handleInitialRoute(currentState);
        }
      }
    } else {
      // Optional: Set lokasi default jika izin ditolak, agar peta tetap tampil
      setState(() {
        _userLocation = const LatLng(-6.9034, 107.6186); // Contoh: Bandung
      });
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Izin lokasi ditolak. Menampilkan peta di lokasi default.")),
        );
      }
      // FIX TIMING (lokasi default): Lakukan pengecekan rute awal juga di sini
      if (_initialTujuanLat != null && _initialTujuanLng != null) {
        final currentState = context.read<MapBloc>().state;
        if (currentState is MapLoaded) {
          _handleInitialRoute(currentState);
        }
      }
    }
  }


  // Fungsi saat pengguna klik pada marker
  //item nama variabel -> bisa diganti apa aja
  void _onMarkerTapped(MapModel item) {
    setState(() {
      selectedTempat = item;
      _routePoints = []; //hapus rute lama kalo ada marker baru yang di klik
    });

    // Pindahkan map ke lokasi yang dipilih
    _animatedMapMove(LatLng(item.lat, item.lng), 19.0); //ini buat atur seberapa jauh zoom in kalau titik lokasi di pilih
  }


  //fungsi animasi buat atur zoom in out pas di klik salah satu titik
  void _animatedMapMove(LatLng dest, double zoom) {
    final camera = _mapController.camera;
    final latTween = Tween<double>(begin: camera.center.latitude, end: dest.latitude);
    final lngTween = Tween<double>(begin: camera.center.longitude, end: dest.longitude);
    // final zoomTween = Tween<double>(begin: camera.zoom, end: zoom);

    // biar nggak zoom out → ambil max antara zoom sekarang sama zoom target
    final zoomTween = Tween<double>(begin: camera.zoom, end: zoom > camera.zoom ? zoom : camera.zoom);

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



  // Fungsi untuk rute dari OSRM
  Future<void> _getRoute(LatLng from, LatLng to) async {
    setState(() {
      _routePoints = []; // Hapus rute lama sebelum mengambil rute baru (FIX)
    });

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

    // Tambahkan lokasi user dan lokasi tujuan ke dalam daftar titik untuk menghitung bounds
    final allPoints = [..._routePoints, if (_userLocation != null) _userLocation!];

    // cari batas koordinat (paling utara, selatan, timur, barat)
    var bounds = LatLngBounds.fromPoints(allPoints);

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(50), // jarak dari pinggir layar
      ),
    );
  }


  // FUNGSI KRUSIAL: Menjalankan rute jika ada tujuan awal dari DetailPage
  void _handleInitialRoute(MapLoaded state) {
    // Cek apakah data tujuan awal ada DAN lokasi user sudah didapat
    if (_initialTujuanLat == null || _initialTujuanLng == null || _userLocation == null) {
      return;
    }

    final apiTempat = state.items;

    // 1. Cari data MapModel yang lengkap berdasarkan Lat/Lng tujuan
    final targetTempat = apiTempat.firstWhere(
          (item) => _areDoublesClose(item.lat, _initialTujuanLat!) &&
              _areDoublesClose(item.lng, _initialTujuanLng!),
      orElse: () => MapModel(
        subkategori: '', id: '', nama: '', alamat: '', lat: 0, lng: 0,
        rating: 0, fotoTempat: '', jamOperasi: '', kontak: '', fotoMenu: null,
        fasilitas: null, gambar: null,
      ),
    );

    // 2. Jika tempat ditemukan (id tidak kosong) dan lokasi user ada
    if (targetTempat.id.isNotEmpty && _userLocation != null) {
      setState(() {
        selectedTempat = targetTempat; // Tampilkan detail card
      });

      // 3. Panggil fungsi rute
      _getRoute(
        _userLocation!,
        LatLng(targetTempat.lat, targetTempat.lng),
      );
      // FIX: Tambahkan ini agar peta langsung bergerak ke tujuan dan detail card terlihat
      _animatedMapMove(LatLng(targetTempat.lat, targetTempat.lng), 14.0);
    }

    // 4. Setelah diproses, bersihkan tujuan awal
    _clearInitialDestination();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<MapBloc, MapState>(
          listener: (context, state) {
            if (state is MapError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${state.message}")),
              );
            }
            //!!UNTUK MEMICU _handleInitialRoute HANYA SETELAH DATA PETA DIMUAT YEAH
            if (state is MapLoaded) {
              _handleInitialRoute(state);
            }
          },
          builder: (context, state) {
            if (_userLocation == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MapLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MapLoaded) {
              final apiTempat = state.items; //hasil dari API
              if (apiTempat.isEmpty) {
                return Center(child: Text("Tidak ada data ${widget.subkategori} ditemukan."));
              }

              return Stack(
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
                        userAgentPackageName: 'com.example.maps',
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
                          ...apiTempat.map((place) => Marker(
                            point: LatLng(place.lat, place.lng),
                            width: 80,
                            height: 80,
                            child: GestureDetector( //widget untuk mendeteksi interaksi user
                              onTap: () {
                                setState(() {
                                  selectedTempat = place; //simpan objek MapModel
                                });
                                  _animatedMapMove(LatLng(place.lat, place.lng), 18.0);
                              },
                              child: Icon(
                                Icons.location_on,
                                color: selectedTempat?.nama == place.nama
                                    ? Colors.red
                                    : Colors.redAccent,
                                size: selectedTempat?.nama== place.nama ? 45 : 40,
                              ),
                            ),
                          )
                          ),
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
                                    selectedTempat!.nama,
                                    // selectedTempat!['nama'],
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
                              // if (selectedTempat!['alamat'] != null) ...[
                                Text(
                                  selectedTempat!.alamat,
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                              // ],

                              // Rating
                              // if (selectedTempat!['rating'] != null) ...[
                                Row(
                                  children: [
                                    ...List.generate(5, (index) {
                                      return Icon(
                                        Icons.star,
                                        color: index < selectedTempat!.rating.round()
                                            ? Colors.orange
                                            : Colors.grey[300],
                                        size: 16,
                                      );
                                    }),
                                    const SizedBox(width: 8),
                                    Text(
                                    selectedTempat!.rating.toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                              // ],

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
                                      onPressed: () {
                                        if (_userLocation != null && selectedTempat != null) {
                                          _getRoute(
                                            _userLocation!,
                                            LatLng(selectedTempat!.lat, selectedTempat!.lng),
                                          );
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
                    bottom: selectedTempat != null ? 250 : 150, //angka itu buat atur posisi bottom mau naik seberapa
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
              );
            }
            return const Center(child: Text("Tidak ada data"));
          },
        ),


      );
  }
}
import '../model/map_model.dart';
import '../model/tempat.dart';


class MapRepo {

  //method fetchMapData
  Future<List<MapModel>> fetchMapData(String subkategori) async {  //kenapa ada subkategori? ini tuh mksdnya dia ambil subkategori dari TempatByKategori
    await Future.delayed(const Duration(milliseconds: 500));

    final rawDataList = TempatByKategori[subkategori] ?? []; //nah ini kasih subkategori dan TempatByKategori

    if (rawDataList.isEmpty) { //ini kalo datanya kosong langsung return list kosong yeah
      return [];
    }

    return rawDataList.map((map) {  //ini elemen map diubah jadi mapmodel 
      return MapModel.fromJson(map);
    }).toList();
  }
}













// class MapRepo {
//   // static const String _baseUrl = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime={{eq-starttime}}&endtime={{eq-endtime}}";
//
//
//   Future<List<MapModel>> fetchData() async{
//     // final url = Uri.parse(_baseUrl);
//     // final response = await http.get(url);
//     //
//     //     if (response.statusCode == 200) {
//     //       final data = json.decode(response.body) as Map<String,dynamic>;
//     //       final features = data['features'] as List<dynamic>? ?? [];
//     //       return features.map((e) => MapModel.fromJson(e)).toList();
//     //     } else {
//     //       throw Exception("Gagal memuat data: ${response.statusCode}");
//     //     }
//
//     // --- LOGIKA REPOSITORY TANPA API (MENGEMBALIKAN DATA KOSONG) ---
//     await Future.delayed(const Duration(milliseconds: 500)); // Simulasi loading
//     return []; // Mengembalikan list kosong untuk simulasi
//   }
//
//   Future<List<String>> fetchSubCategories() async {
//     // final url = Uri.parse(_baseUrl);
//     // final response = await http.get(url);
//
//     // if (response.statusCode == 200) {
//     //   final data = json.decode(response.body) as Map<String,dynamic>;
//     //   final features = data['features'] as List<dynamic>? ?? [];
//     //   // ambil semua type dan buang duplikat
//     //   final types = features.map((e) => e['properties']['type'] as String).toSet().toList();
//     //   return types;
//     // } else {
//     //   throw Exception("Gagal memuat sub-kategori: ${response.statusCode}");
//     // }
//
//     // --- LOGIKA REPOSITORY TANPA API (MENGEMBALIKAN DATA LOKAL) ---
//     await Future.delayed(const Duration(milliseconds: 500)); // Simulasi loading
//
//     // Kembalikan list sub-kategori (value) berdasarkan key kategori
//     final subKategoriList = menuByKategori[kategoriKey];
//
//     if (subKategoriList != null) {
//       return subKategoriList;
//     } else {
//       // Jika kategori tidak ditemukan (seharusnya tidak terjadi)
//       return [];
//     }
//   }
// }
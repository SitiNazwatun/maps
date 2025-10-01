import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
  @override
  List<Object> get props => [];
}


class FetchSubCategories extends MapEvent {} //buat ambil data subkategori, cuman trigger bukan manggil

class FetchData extends MapEvent { //ini untuk ambil data berdasarkan subkategori tertentu
  final String subkategori;
  const FetchData({required this.subkategori});
  @override
  List<Object> get props => [subkategori]; //supaya dua event dengan subkategori yg sama dianggap sama oleh Equatable
}
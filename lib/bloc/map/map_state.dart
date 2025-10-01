import 'package:equatable/equatable.dart';
import '../../model/map_model.dart';

abstract class MapState extends Equatable {
  const MapState();
  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState { //data berhasil diambil. menyimpan daftar data list (items) dalam bentuk list<mapmodel>
  final List<MapModel> items;
  const MapLoaded(this.items);

}

class SubKategoriLoaded extends MapState { //state kalau data yang diambil berupa subkagetori, contoh restoran, cafe dll
  final List<String> subkategori;
  SubKategoriLoaded(this.subkategori);
}

class MapError extends MapState { //state pas error. nyimpen pesan error di message
  final String message;
  MapError(this.message);
  //
  // const MapError(this.message);
  // @override
  // List<Object> get props => [message];
}


import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositorie/map_repo.dart';
import '../../bloc/map/map_event.dart';
import '../../bloc/map/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepo mapRepo;

  // MapBloc(this.mapRepo, {required MapRepo}) : super(MapInitial()) {
  // yg diatas itu error? KENAPA? KARENA UDAH ADA THIS MALAH REQUIRED LAGI ANJAY JADI ADA DUA GTU DAH
  MapBloc(this.mapRepo) : super(MapInitial()) {
    on<FetchData>(_onFetchData);
  }

  Future<void> _onFetchData
      (FetchData event,
      Emitter<MapState> emit,
      ) async {
    //Emit state Loading sebelum memanggil Repo
    emit(MapLoading());

    try {
      // Panggil Repo dengan subkategori dari event
      final fetchedTempat = await mapRepo.fetchMapData(event.subkategori);
      // Emit state Loaded dengan data yang berhasil didapat
      emit(MapLoaded(fetchedTempat));

    } catch (e) {
      // Emit state Error jika terjadi masalah
      emit(MapError(e.toString()));
    }
  }
}
class Place {
  final String name;
  final double lat;
  final double lng;

  Place({required this.name, required this.lat, required this.lng});
}


final Map<String, List<Place>> placesByCategory = {
  'Restoran': [
    Place(name: 'Resto Pahlawan', lat: -6.8937, lng: 107.6374),
    Place(name: 'Resto Cikutra', lat: -6.8940, lng: 107.6378),
    Place(name: 'Resto Sukapura', lat: -6.8935, lng: 107.6370),
    Place(name: 'Resto Bandung Timur', lat: -6.8939, lng: 107.6372),
  ],
  'Kafe': [
    Place(name: 'Cafe Jalan Pahlawan', lat: -6.8938, lng: 107.6376),
    Place(name: 'Cafe Cikutra', lat: -6.8936, lng: 107.6372),
    Place(name: 'Cafe Sukapura', lat: -6.8941, lng: 107.6375),
  ],
  'Toko Roti': [
    Place(name: 'Toko Roti Pahlawan', lat: -6.8937, lng: 107.6374),
    Place(name: 'Toko Roti Cikutra', lat: -6.8940, lng: 107.6378),
    Place(name: 'Toko Roti Sukapura', lat: -6.8935, lng: 107.6370),
  ],
  'Apotek': [
    Place(name: 'Apotek Cikutra', lat: -6.8937, lng: 107.6374),
    Place(name: 'Apotek Pahlawan', lat: -6.8938, lng: 107.6373),
    Place(name: 'Apotek Sukapura', lat: -6.8940, lng: 107.6372),
  ],
  'Sekolah': [
    Place(name: 'SD Cikutra', lat: -6.8935, lng: 107.6374),
    Place(name: 'SMP Pahlawan', lat: -6.8937, lng: 107.6376),
    Place(name: 'SMA Sukapura', lat: -6.8939, lng: 107.6372),
  ],
  'Supermarket': [
    Place(name: 'Indomaret Pahlawan', lat: -6.8936, lng: 107.6375),
    Place(name: 'Alfamart Cikutra', lat: -6.8938, lng: 107.6374),
  ],
};

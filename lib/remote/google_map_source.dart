import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GoogleMapSource {
  Future<Map<String, dynamic>> getRoute(LatLng origin, LatLng destination);
}

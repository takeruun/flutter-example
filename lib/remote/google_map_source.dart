import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GoogleMapSource {
  Future<void> onMapCreated(GoogleMapController controller);

  Future<void> cameraUpdate(LatLng latLng, GoogleMapController controller);
}

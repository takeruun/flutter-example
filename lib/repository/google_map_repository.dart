import 'package:example/model/result.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GoogleMapRepository {
  Future<Result<void>> onMapCreated(GoogleMapController controller);

  Future<Result<void>> cameraUpdate(
      LatLng latLng, GoogleMapController controller);
}

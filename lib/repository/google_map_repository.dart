import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:example/model/result.dart';

abstract class GoogleMapRepository {
  Future<Result<Map<String, dynamic>>> getRoute(
      LatLng origin, LatLng destination);
}

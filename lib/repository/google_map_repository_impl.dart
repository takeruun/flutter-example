import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:example/model/result.dart';
import 'package:example/repository/google_map_repository.dart';
import 'package:example/remote/google_map_source.dart';
import 'google_map_repository.dart';

class GoogleMapRepositoryImpl implements GoogleMapRepository {
  final GoogleMapSource _googleMapSource;
  GoogleMapRepositoryImpl(this._googleMapSource);

  Future<Result<Map<String, dynamic>>> getRoute(
      LatLng origin, LatLng destination) {
    return Result.guardFuture(
        () => _googleMapSource.getRoute(origin, destination));
  }
}

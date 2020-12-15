import 'package:example/model/result.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:example/repository/google_map_repository.dart';
import 'package:example/remote/google_map_source.dart';
import 'google_map_repository.dart';

class GoogleMapRepositoryImpl implements GoogleMapRepository {
  final GoogleMapSource _googleMapSource;
  GoogleMapRepositoryImpl(this._googleMapSource);

  Future<Result<void>> onMapCreated(GoogleMapController controller) {
    return Result.guardFuture(() => _googleMapSource.onMapCreated(controller));
  }

  Future<Result<void>> cameraUpdate(
      LatLng latLng, GoogleMapController controller) {
    return Result.guardFuture(
        () => _googleMapSource.cameraUpdate(latLng, controller));
  }
}

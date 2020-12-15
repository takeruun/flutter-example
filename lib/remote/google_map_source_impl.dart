import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'google_map_source.dart';

class GoogleMapSourceImpl implements GoogleMapSource {
  final Completer<GoogleMapController> _controller;
  GoogleMapSourceImpl(this._controller);

  Future<void> onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) _controller.complete(controller);
  }

  Future<void> cameraUpdate(LatLng latLng, GoogleMapController controller) {
    return _controller.future
        .then((_) => controller.animateCamera(CameraUpdate.newLatLng(latLng)));
  }
}

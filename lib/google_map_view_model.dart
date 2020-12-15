import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:example/repository/google_map_repository.dart';
import 'package:example/provider/google_map_repository_provider.dart';

final googleMapViewModel = ChangeNotifierProvider(
    (ref) => GoogleMapViewModel(ref.read(googleMapRepositoryProvider)));

class GoogleMapViewModel extends ChangeNotifier {
  final GoogleMapRepository _repository;

  StreamSubscription _locationChangedListen;

  static LatLng _latLng;
  LatLng get latLng => _latLng;

  Set<Polyline> _polylines;
  Set<Polyline> get polylines => _polylines;

  GoogleMapController _controller;

  Position _position;

  GoogleMapViewModel(this._repository) {
    getCurrentPosition();
    _locationChangedListen = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ).listen((Position result) {
      if (_controller != null)
        _repository.cameraUpdate(
            LatLng(result.latitude, result.longitude), _controller);
    });
  }

  void onMapCreated(GoogleMapController controller) {
    _repository.onMapCreated(controller);
    _controller = controller;
  }

  void onCameraMove(CameraPosition position) {
    _latLng = position.target;
    notifyListeners();
  }

  void getCurrentPosition() async {
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _latLng = LatLng(_position.latitude, _position.longitude);
    notifyListeners();
  }
}

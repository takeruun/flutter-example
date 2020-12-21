import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:example/repository/google_map_repository.dart';
import 'package:example/provider/google_map_repository_provider.dart';

import 'model/location.dart';

final googleMapViewModel = ChangeNotifierProvider(
    (ref) => GoogleMapViewModel(ref.read(googleMapRepositoryProvider)));

class GoogleMapViewModel extends ChangeNotifier {
  final GoogleMapRepository _repository;

  StreamSubscription _locationChangedListen;

  static LatLng _initialLatLng;
  LatLng get initialLatLng => _initialLatLng;

  static LatLng _latLng;
  LatLng get latLng => _latLng;

  String _expectedTime;
  String get expectedTime => _expectedTime;

  Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  GoogleMapController _controller;

  Position _position;

  String _targetUserUid;
  String get targetUserUid => _targetUserUid;
  void setTargetUserUid(String userUid) => _targetUserUid = userUid;

  List<Location> _targetLocation;
  List<Location> get targetLocation => _targetLocation;
  void setTargetLocation(List<Location> location) => _targetLocation = location;

  GoogleMapViewModel(this._repository) {
    getCurrentPosition();
    _locationChangedListen = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 10,
    ).listen((Position result) {
      _latLng = LatLng(result.latitude, result.longitude);
      //if (_controller != null)
      //_controller.animateCamera(CameraUpdate.newLatLng(_latLng));
    });
  }

  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void onCameraMove(CameraPosition position) {
    //_latLng = position.target;
    //notifyListeners();
  }

  void getCurrentPosition() async {
    try {
      _position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _initialLatLng = LatLng(_position.latitude, _position.longitude);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENITED')
        print('Permission denited');
      else if (e.code == 'PERMISSION_DENITED_NEVER_ASK')
        print(
            'Permission denited - please ask the user to enable it from the app settings');
    }
    notifyListeners();
  }

  Timer sample() {
    return Timer.periodic(Duration(seconds: 5), (Timer t) {
      print(t.tick);
    });
  }

  Future<void> rewritePolyline(List<Location> location) {
    return _repository
        .getRoute(
            _latLng, LatLng(location.last.latitude, location.last.longitude))
        .then((result) {
      result.ifSuccess((data) {
        _expectedTime = data['legs'][0]['duration'].toString();
        Polyline polyline = createRoute(data["overview_polyline"]["points"]);
        _polylines.clear();
        Marker pm = _markers.firstWhere(
            (marker) => marker.markerId.value == 'partner_Marker',
            orElse: () => null);
        _markers.remove(pm);
        _markers.add(
          Marker(
            markerId: MarkerId('parter_Marker'),
            position: LatLng(location.last.latitude, location.last.longitude),
            infoWindow: InfoWindow(title: 'Patner Marker'),
          ),
        );
        _polylines.add(polyline);
        notifyListeners();
      });
    });
  }

  Polyline createRoute(String encondedPoly) {
    return Polyline(
      polylineId: PolylineId(_latLng.toString()),
      width: 4,
      points: _convertToLatLng(_decodePoly(encondedPoly)),
      color: Colors.red,
    );
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    return lList;
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }
}

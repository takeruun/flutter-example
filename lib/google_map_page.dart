import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:example/map_request.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

String apiKey = DotEnv().env['GOOGLE_MAP_API_KEY'];

class GoogleMapPage extends StatefulWidget {
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final Set<Polyline> _polyLines = {};
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  Set<Polyline> get polyLines => _polyLines;
  Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation;
  Location _location = new Location();
  static LatLng latLng;
  String error;

  Set<Polyline> _polylines_n = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('marker_1'),
      position: LatLng(37.42796133580664, -122.085749655962),
      infoWindow: InfoWindow(title: 'marker_1'),
    ),
    Marker(
      markerId: MarkerId('marker_2'),
      position: LatLng(38.42796133580664, -122.085745655962),
      infoWindow: InfoWindow(title: 'marker_2'),
    )
  };

  @override
  void initState() {
    super.initState();

    initPlatformState();
    _location.onLocationChanged.listen((LocationData result) async {
      if (mounted) {
        setState(() {
          currentLocation = result;
          latLng = LatLng(result.latitude, result.longitude);
          _markers.add(Marker(
            markerId: MarkerId('現在位置'),
            position: latLng,
            icon: BitmapDescriptor.defaultMarker,
          ));
        });
      }
    });
  }

  initPlatformState() async {
    LocationData myLocation;
    myLocation = await _location.getLocation();
    try {
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENITED')
        error = 'Permission denited';
      else if (e.code == 'PERMISSION_DENITED_NEVER_ASK')
        error =
            'Permission denited - please ask the user to enable it from the app settings';
      myLocation = null;
    }
    if (mounted) {
      setState(() {
        currentLocation = myLocation;
      });
    }
  }

  void onCameraMove(CameraPosition position) {
    latLng = position.target;
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

  void sendRequest() async {
    LatLng destination = LatLng(37.42796133580664, -122.085749655962);
    String route =
        await _googleMapsServices.getRouteCoordinates(latLng, destination);
    createRoute(route);
    //_addMarker(destination, "KTHM Collage");
  }

  void createRoute(String encondedPoly) {
    _polyLines.add(
      Polyline(
        polylineId: PolylineId(latLng.toString()),
        width: 4,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.red,
      ),
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

    print(lList.toString());

    return lList;
  }

  void setPolylines(LatLng current) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(37.42796133580664, -122.085749655962),
      PointLatLng(current.latitude, current.longitude),
      travelMode: TravelMode.driving,
    );
    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    addPolylines();
  }

  void addPolylines() {
    Polyline polyline = Polyline(
        polylineId: PolylineId("poly"),
        color: Color.fromARGB(255, 40, 122, 198),
        width: 2,
        points: polylineCoordinates);

    setState(() {
      _polylines_n.add(polyline);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('google map'),
      ),
      body: Scaffold(
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.7,
              child: GoogleMap(
                polylines: _polylines_n,
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: _markers,
                onCameraMove: onCameraMove,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
            Text('現在地' + currentLocation.toString()),
            RaisedButton(
              child: Text('goToNow'),
              onPressed: () => _goToNow(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setPolylines(latLng),
        label: Text('Distination'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> _goToNow() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 17.0),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    LocationData myLocation;
    try {
      myLocation = await _location.getLocation();
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENITED')
        error = 'Permission denited';
      else if (e.code == 'PERMISSION_DENITED_NEVER_ASK')
        error =
            'Permission denited - please ask the user to enable it from the app settings';
      myLocation = null;
    }
    setState(() {
      currentLocation = myLocation;
    });
  }

  Future<bool> checkLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
}

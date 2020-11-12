import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:example/map_request.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/user_data.dart';

String apiKey = DotEnv().env['GOOGLE_MAP_API_KEY'];

class GoogleMapPage extends StatefulWidget {
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final Set<Polyline> _polylines = {};
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  Set<Polyline> get polyLines => _polylines;
  Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation;
  Location _location = new Location();
  static LatLng _latLng;
  String error;
  StreamSubscription _locationChangedListen;

  Set<Polyline> _polylines_n = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  DocumentSnapshot _data;
  String _parterUserUid = '';
  Timer _timer;

  final GlobalKey<FormState> _timeFormKey = GlobalKey<FormState>();
  TextEditingController _timeEditController;

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
  };

  @override
  void initState() {
    super.initState();

    currentUserCheck();
    initPlatformState();

    _locationChangedListen =
        _location.onLocationChanged.listen((LocationData result) async {
      if (mounted) {
        setState(() {
          currentLocation = result;
          _latLng = LatLng(result.latitude, result.longitude);
          /*
          _markers.add(Marker(
            markerId: MarkerId('me_marker'),
            position: _latLng,
            icon: BitmapDescriptor.defaultMarker,
          ));
          */
        });
      }
    });
    _timer = sample();
    _timeEditController = new TextEditingController();
  }

  @override
  void dispose() {
    _timer.cancel();
    _locationChangedListen?.cancel();
    super.dispose();
  }

  void currentUserCheck() async {
    _user = _auth.currentUser;
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
      FirebaseFirestore.instance.collection("location").add({
        'user_uid': _user.uid,
        'latitude': myLocation.latitude,
        'longitude': myLocation.longitude,
        'created_at': DateTime.now().toString(),
      });
    }
  }

  void onCameraMove(CameraPosition position) {
    _latLng = position.target;
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

  void sendRequest(LatLng partnerLatLng) async {
    String route =
        await _googleMapsServices.getRouteCoordinates(_latLng, partnerLatLng);
    _polylines.clear();
    Marker parM = _markers.firstWhere(
        (marker) => marker.markerId.value == 'partner_Marker',
        orElse: () => null);
    _markers.remove(parM);
    if (parM == null)
      _markers.add(
        Marker(
          markerId: MarkerId('parter_Marker'),
          position: LatLng(partnerLatLng.latitude, partnerLatLng.longitude),
          infoWindow: InfoWindow(title: 'Patner Marker'),
        ),
      );
    createRoute(route);
    //_addMarker(destination, "KTHM Collage");
  }

  void createRoute(String encondedPoly) {
    Polyline polyline = Polyline(
      polylineId: PolylineId(_latLng.toString()),
      width: 4,
      points: _convertToLatLng(_decodePoly(encondedPoly)),
      color: Colors.red,
    );
    setState(() {
      _polylines.add(polyline);
    });
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

    //print(lList.toString());

    return lList;
  }

  void setPolylines(LatLng current) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(current.latitude, current.longitude),
      PointLatLng(37.42796133580664, -122.085749655962),
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

  void rewritePolyline(data) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(data['latitude'], data['longitude']),
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      travelMode: TravelMode.driving,
    );
    polylineCoordinates.clear();
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    Marker parM = _markers.firstWhere(
        (marker) => marker.markerId.value == 'partner_Marker',
        orElse: () => null);
    _markers.remove(parM);
    if (parM == null)
      _markers.add(
        Marker(
          markerId: MarkerId('parter_Marker'),
          position: LatLng(data['latitude'], data['longitude']),
          infoWindow: InfoWindow(title: 'Patner Marker'),
        ),
      );
    addPolylines();
  }

  Timer sample() {
    return Timer.periodic(Duration(seconds: 10), (Timer t) {
      print(_latLng.toString());
      //rewritePolyline(_data);
      if (_data != null)
        sendRequest(LatLng(_data['latitude'], _data['longitude']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('google map'),
      ),
      body: Scaffold(
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              child: GoogleMap(
                polylines: _polylines,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: _latLng,
                  zoom: 14.4746,
                ),
                markers: _markers,
                onCameraMove: onCameraMove,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
            //Text('現在地' + currentLocation.toString()),
            /*
            RaisedButton(
              child: Text('goToNow'),
              onPressed: () => _goToNow(),
            ),
            */
            RaisedButton(
              child: Text('位置情報送信'),
              onPressed: () => sendLocation(),
            ),
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('location')
                    .orderBy('created_at', descending: true)
                    .where('user_uid', isEqualTo: _parterUserUid)
                    .limit(1)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  //if (snapshot.connectionState == ConnectionState.waiting) {
                  //  return Text("Loading...");
                  //}
                  if (snapshot.hasData) {
                    return LimitedBox(
                      maxHeight: 150,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, index) {
                          _data = snapshot.data.docs[index];
                          return Text(_data['user_uid']);
                        },
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
            RaisedButton(
              child: Text('Please select'),
              onPressed: _showUserDialog,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _goToNow,
        label: Text('Distination'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  void sendLocation() {
    FirebaseFirestore.instance.collection("location").add({
      'user_uid': _user.uid,
      'latitude': _latLng.latitude,
      'longitude': _latLng.longitude,
      'created_at': DateTime.now().toString(),
    });
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

  Future<List<UserData>> getUsers() async {
    QuerySnapshot qShot =
        await FirebaseFirestore.instance.collection('users').get();

    return qShot.docs
        .map((doc) =>
            UserData(uid: doc['uid'], name: doc['name'], email: doc['email']))
        .toList();
  }

  Future _showUserDialog() async {
    List<UserData> users = await getUsers();
    String uid = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('ユーザ選択'),
          children: users
              .map(
                (user) => SimpleDialogOption(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.shade200,
                      child: Text(
                        user.name,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    title: Text(user.email),
                  ),
                  onPressed: () {
                    Navigator.pop(context, user.uid);
                  },
                ),
              )
              .toList(),
        );
      },
    );
    setState(() {
      _parterUserUid = uid;
    });
  }
}

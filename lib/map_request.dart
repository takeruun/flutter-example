import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String apiKey = DotEnv().env['GOOGLE_MAP_API_KEY'];

class GoogleMapsServices {
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    print(l1.toJson());
    print(l2.toJson());
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&mode=driving&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    print("====================>>>>>>>>${values}");

    return values["routes"][0]["overview_polyline"]["points"];
  }
}

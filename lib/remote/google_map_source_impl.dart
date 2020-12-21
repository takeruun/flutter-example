import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'google_map_source.dart';

String apiKey = DotEnv().env['GOOGLE_MAP_API_KEY'];

class GoogleMapSourceImpl implements GoogleMapSource {
  Future<Map<String, dynamic>> getRoute(
      LatLng origin, LatLng destination) async {
    var url =
        "https://maps.googleapis.com/maps/api/directions/json?language=ja&origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=$apiKey";
    var response = await http.get(url);
    var values = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return values["routes"][0];
    } else {
      throw (values);
    }
  }
}

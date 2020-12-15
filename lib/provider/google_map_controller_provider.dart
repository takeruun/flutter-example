import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final googleMapControllerProvider = Provider<Completer<GoogleMapController>>(
    (_) => Completer<GoogleMapController>());

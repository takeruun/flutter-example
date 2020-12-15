import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:example/remote/google_map_source.dart';
import 'package:example/remote/google_map_source_impl.dart';

import 'google_map_controller_provider.dart';

final googleMapSourceProvider = Provider<GoogleMapSource>(
    (ref) => GoogleMapSourceImpl(ref.read(googleMapControllerProvider)));

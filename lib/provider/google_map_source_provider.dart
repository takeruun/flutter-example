import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:example/remote/google_map_source.dart';
import 'package:example/remote/google_map_source_impl.dart';

final googleMapSourceProvider =
    Provider<GoogleMapSource>((_) => GoogleMapSourceImpl());

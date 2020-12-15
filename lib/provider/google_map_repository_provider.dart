import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:example/repository/google_map_repository.dart';
import 'package:example/repository/google_map_repository_impl.dart';

import 'google_map_source_provider.dart';

final googleMapRepositoryProvider = Provider<GoogleMapRepository>(
    (ref) => GoogleMapRepositoryImpl(ref.read(googleMapSourceProvider)));

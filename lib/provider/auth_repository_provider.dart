import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:example/repository/auth_repository.dart';
import 'package:example/repository/auth_repository_impl.dart';

import 'auth_data_source_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => AuthRepositoryImpl(ref.read(authDataSourceProvider)));

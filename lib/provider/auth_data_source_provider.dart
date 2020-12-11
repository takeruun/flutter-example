import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:example/remote/auth_data_source.dart';
import 'package:example/remote/auth_data_source_impl.dart';

import 'firebase_auth_provider.dart';

final authDataSourceProvider = Provider<AuthDataSource>(
    (ref) => AuthDataSourceImpl(ref.read(firebaseAuthProvider)));

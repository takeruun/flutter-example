import 'package:firebase_auth/firebase_auth.dart';

import 'package:example/model/source.dart';

abstract class AuthDataSource {
  Future<User> getCurrentUser();

  Future<User> googleSignIn();

  Future<void> signOut();

  Future<List<Source>> getUsers();
}

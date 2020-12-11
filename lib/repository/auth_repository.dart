import 'package:firebase_auth/firebase_auth.dart' as Firebase;

import 'package:example/model/result.dart';

abstract class AuthRepository {
  Future<Result<Firebase.User>> getCurrentUser();

  Future<Result<Firebase.User>> googleSignIn();

  Future<Result<void>> signOut();
}

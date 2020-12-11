import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_data_source.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthDataSourceImpl(this._firebaseAuth);

  @override
  Future<User> googleSignIn() async {
    final account = await GoogleSignIn().signIn();
    if (account == null) {
      return throw StateError('Maybe user canceled.');
    }
    final auth = await account.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );

    final credential = await _firebaseAuth.signInWithCredential(authCredential);
    final currentUser = await FirebaseAuth.instance.currentUser;
    assert(credential.user.uid == currentUser.uid);
    return credential.user;
  }

  @override
  Future<void> signOut() {
    return GoogleSignIn()
        .signOut()
        .then((_) => _firebaseAuth.signOut())
        .catchError((error) {
      debugPrint(error.toString());
      throw error;
    });
  }
}

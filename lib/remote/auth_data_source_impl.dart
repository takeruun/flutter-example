import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:example/model/source.dart' as user;
import 'auth_data_source.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthDataSourceImpl(this._firebaseAuth);

  @override
  Future<User> getCurrentUser() async {
    final currentUser = await _firebaseAuth.currentUser;
    return currentUser;
  }

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

  @override
  Future<List<user.Source>> getUsers() async {
    List<user.Source> data;
    QuerySnapshot docSnapshot =
        await FirebaseFirestore.instance.collection("users").get();

    data = docSnapshot.docs
        .map((element) => user.Source.fromJson(element.data()))
        .toList();

    return data;
  }
}

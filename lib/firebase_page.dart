import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:example/register_page.dart';
import 'package:example/login_page.dart';

class FirebasePage extends StatefulWidget {
  @override
  _FirebasePageState createState() => _FirebasePageState();
}

class _FirebasePageState extends State<FirebasePage> {
  User _user;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void initState() {
    currentUserCheck();
  }

  void currentUserCheck() async {
    _user = _auth.currentUser;
  }

  void _setUser(User user) {
    setState(() {
      _user = user;
    });
  }

  Future<User> _handleSignIn() async {
    GoogleSignInAccount currentUser = _googleSignIn.currentUser;
    try {
      currentUser ??= await _googleSignIn.signInSilently();
      currentUser ??= await _googleSignIn.signIn();
      if (currentUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await currentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      return user;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _handleSignOut() async {
    await _auth.signOut();
    try {
      await _googleSignIn.signOut();
      _setUser(null);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('firebase page')),
      body: _user == null ? googleAuthBtn() : chat(),
    );
  }

  Widget googleAuthBtn() {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            padding: EdgeInsets.all(10.0),
            onPressed: () {
              _handleSignIn().then((User user) => _setUser(user)).catchError(
                    (e) => print(e),
                  );
            },
            child: Text('Google 認証'),
          ),
          RaisedButton(
            child: Text('ユーザ作成'),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
          ),
          RaisedButton(
              child: Text('ログイン'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }),
        ],
      )),
    );
  }

  Widget chat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            child: Text('google 認証解除'),
            onPressed: () {
              _handleSignOut().catchError((e) => print(e));
            },
          ),
          Text('chat'),
          Text(_user.uid)
        ],
      ),
    );
  }
}

import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:example/notification.dart' as notif;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:example/google_map_page.dart';
import 'package:example/sign_in_page.dart';

const myTask = 'location';

void main() async {
  await DotEnv().load('.env');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(child: App()),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'example',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return somethingWentWrong();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MyApp();
          }
          return loading();
        },
      ),
    );
  }

  Widget somethingWentWrong() {
    return Scaffold(
        body: Center(
      child: Text('error'),
    ));
  }

  Widget loading() {
    return Scaffold(
      body: Center(
        child: Text('Loading'),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static const _channel =
      const MethodChannel('tk.location.sample/background_location');

  bool _flag = false;

  Future<void> _startBackLocation() async {
    if (Platform.isAndroid) {
      await PermissionsPlugin.requestPermissions([
        Permission.ACCESS_COARSE_LOCATION,
        Permission.ACCESS_FINE_LOCATION,
      ]);
    }
    setState(() {
      _flag = !_flag;
      _setFlagPrefs();
    });
  }

  Future<void> _stopBackLocation() async {
    await _channel.invokeMethod('stopLocation');
  }

  _setFlagPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('flag', _flag);
  }

  _getFlagPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _flag = prefs.getBool('flag') ?? false;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _getFlagPrefs();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      Map data = <String, dynamic>{'flag': _flag, 'user_uid': 'sample'};
      await _channel.invokeMethod('getLocation', data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              child: Text('to google map'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GoogleMapPage()));
              },
            ),
            RaisedButton(
              child: Text('Sign Page'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInPage()));
              },
            ),
            RaisedButton(
              child: _flag
                  ? Text('start background location')
                  : Text('stop background location'),
              onPressed: _startBackLocation,
            ),
            RaisedButton(
              child: Text('stop background'),
              onPressed: _stopBackLocation,
            ),
          ],
        ),
      ),
    );
  }
}

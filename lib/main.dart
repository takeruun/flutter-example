import 'package:flutter/material.dart';
import 'dart:async';
import 'package:example/google_map_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:example/firebase_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await CallKeep.setup();
  await DotEnv().load('.env');
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'example',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialzed = false;
  bool _error = false;

  void initializaFutureFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialzed = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializaFutureFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return SomethingWentWrong();
    }
    if (!_initialzed) {
      return loading();
    }
    return body(context);
  }

  Widget SomethingWentWrong() {
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

  Widget body(BuildContext context) {
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
            child: Text('firebase page'),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FirebasePage()));
            },
          )
        ],
      )),
    );
  }
}

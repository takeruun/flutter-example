import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/main.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  TextEditingController nameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  void initState() {
    nameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    return null;
  }

  String pwdValidator(String value) {
    if (value.length < 6) {
      return '6桁以上で入力しろ';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ユーザ作成')),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _registerFormKey,
            child: Column(
              children: [
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Name*', hintText: 'Take'),
                  controller: nameInputController,
                  validator: (value) {
                    if (value.length < 3) {
                      return '3文字にしろ';
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Email*', hintText: 'take@gmail.com'),
                  controller: emailInputController,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Password*', hintText: '******'),
                  controller: pwdInputController,
                  obscureText: true,
                  validator: pwdValidator,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                RaisedButton(
                    child: Text('アカウント作成'),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_registerFormKey.currentState.validate()) {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailInputController.text,
                                password: pwdInputController.text)
                            .then(
                              (currentUser) => FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(currentUser.user.uid)
                                  .set({
                                'uid': currentUser.user.uid,
                                'name': nameInputController.text,
                                'email': emailInputController.text,
                              }).then(
                                (result) => {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyApp()),
                                      (_) => false),
                                  nameInputController.clear(),
                                  emailInputController.clear(),
                                  pwdInputController.clear(),
                                },
                              ),
                            );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

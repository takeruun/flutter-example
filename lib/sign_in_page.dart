import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:example/user_view_model.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: Body(),
      ),
    );
  }
}

class Body extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isSignIn = useProvider(
        userViewModelProvider.select((value) => value.isAuthenicated));
    if (isSignIn) {
      final user =
          useProvider(userViewModelProvider.select((value) => value.user));
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ユーザID : ' + user.uid),
          Text('ユーザemail : ' + user.email),
          RaisedButton(
            child: Text('google logout'),
            onPressed: () => context.read(userViewModelProvider).signOut(),
          )
        ],
      );
    } else {
      return RaisedButton(
        child: Text('Google 認証'),
        onPressed: () => context.read(userViewModelProvider).googleSignIn(),
      );
    }
  }
}

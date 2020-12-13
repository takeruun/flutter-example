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
          ),
          RaisedButton(
            child: Text('get Users'),
            onPressed: () async {
              await context.read(userViewModelProvider).getUsers();
              final _users = context.read(userViewModelProvider).users;
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('ユーザ選択'),
                    children: _users
                        .map(
                          (user) => SimpleDialogOption(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange.shade200,
                                child: Text(
                                  user.name,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              title: Text(user.email),
                            ),
                            onPressed: () {
                              Navigator.pop(context, user.uid);
                            },
                          ),
                        )
                        .toList(),
                  );
                },
              );
            },
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

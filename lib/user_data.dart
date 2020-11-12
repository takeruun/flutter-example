import 'dart:convert';

class UserData {
  final String uid;
  final String name;
  final String email;

  UserData({this.uid, this.name, this.email});

  Map<String, dynamic> toMap() => {'uid': uid, 'name': name, 'email': email};

  factory UserData.fromMap(Map<String, dynamic> data) => UserData(
        uid: data['user_uid'],
        name: data['name'],
        email: data['email'],
      );
}

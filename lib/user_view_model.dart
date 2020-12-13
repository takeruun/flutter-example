import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/all.dart';

import 'package:example/model/source.dart';
import 'package:example/repository/auth_repository.dart';
import 'package:example/provider/auth_repository_provider.dart';

final userViewModelProvider = ChangeNotifierProvider(
    (ref) => UserViewModel(ref.read(authRepositoryProvider)));

class UserViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  UserViewModel(this._repository) {
    _repository.getCurrentUser().then((result) {
      result.ifSuccess((data) {
        _user = data;
        notifyListeners();
      });
    });
  }

  firebase.User _user;
  firebase.User get user => _user;

  List<Source> _users;
  List<Source> get users => _users;

  bool get isAuthenicated => _user != null;

  Future<void> googleSignIn() {
    return _repository.googleSignIn().then((result) {
      result.ifSuccess((data) {
        _user = data;
        notifyListeners();
      });
    });
  }

  Future<void> signOut() {
    return _repository.signOut().then((result) {
      return result.when(
          success: (_) {
            _user = null;
            notifyListeners();
          },
          failure: (_) => result);
    });
  }

  Future<void> getUsers() {
    return _repository.getUsers().then((result) {
      result.ifSuccess((data) {
        _users = data;
        notifyListeners();
      });
    });
  }
}

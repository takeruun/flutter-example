import 'package:firebase_auth/firebase_auth.dart';

import 'package:example/model/result.dart';
import 'package:example/remote/auth_data_source.dart';

import 'package:example/model/source.dart' as user;
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Result<User>> getCurrentUser() {
    return Result.guardFuture(() => _dataSource.getCurrentUser());
  }

  @override
  Future<Result<User>> googleSignIn() {
    return Result.guardFuture(() => _dataSource.googleSignIn());
  }

  @override
  Future<Result<void>> signOut() {
    return Result.guardFuture(_dataSource.signOut);
  }

  @override
  Future<Result<List<user.Source>>> getUsers() {
    return Result.guardFuture(() => _dataSource.getUsers());
  }
}

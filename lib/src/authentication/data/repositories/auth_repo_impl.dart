import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/api_exception.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/core/utils/typedef.dart';
import 'package:flutter_clean_architecture/src/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/entities/user.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/repositories/auth_repo.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  const AuthenticationRepositoryImplementation(this._remoteDataSource);
  final AuthenticationRemoteDataSource _remoteDataSource;

  @override
  ResultVoid createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    try {
      await _remoteDataSource.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
      return const Right(null);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final result = await _remoteDataSource.getUsers();
      return Right(result);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
}

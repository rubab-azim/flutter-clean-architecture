import 'package:flutter_clean_architecture/core/usecase/usecase.dart';
import 'package:flutter_clean_architecture/core/utils/typedef.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/entities/user.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/repositories/auth_repo.dart';

class GetUsersUsecase extends UseCaseWithOutParams<List<User>> {
  final AuthenticationRepository _repository;
  GetUsersUsecase(this._repository);

  @override
  ResultFuture<List<User>> call() async => _repository.getUsers();
}

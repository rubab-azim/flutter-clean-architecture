import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/repositories/auth_repo.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/usecases/create_user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'authentication_repository.mock.dart';

// We need to ask what does our class takes

// How can we create a fake version of our dependency

// We need to control what the dependencies do

// Mocktail helps us creating fake versions of dependencies

// A class depends on a repository . We can use mocktail to create a fake version of the dependency. Our class depends on AuthenticationRepository.

void main() {
  late CreateUser usecase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = CreateUser(repository);
  });
  const params = CreateUserParams.empty();
  test("Should call [repositor.createUser method]", () async {
    //Arrange

    when(
      () => repository.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar')),
    ).thenAnswer((_) async => const Right(null));
    //Act

    final result = await usecase(params);

    //Assert
    expect(result, equals(const Right<dynamic, void>(null)));

    verify(() => repository.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar)).called(1);
    verifyNoMoreInteractions(repository);
  });
}

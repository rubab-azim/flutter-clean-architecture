import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/entities/user.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/repositories/auth_repo.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/usecases/get_user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsersUsecase getuserUseCase;

  setUp(() {
    repository = MockAuthenticationRepository();
    getuserUseCase = GetUsersUsecase(repository);
  });
  const testResponse = [User.empty()];

  test("should call [AuthRepository.getUser] and return [Listof<User>]",
      () async {
    //Arrange
    when(
      () => repository.getUsers(),
    ).thenAnswer((_) async => const Right(testResponse));
    //Act

    final result = await getuserUseCase();
    //Assert

    expect(result, equals(const Right<dynamic, List<User>>(testResponse)));
    verify(() => repository.getUsers()).called(1);
    verifyNoMoreInteractions(repository);
  });
}

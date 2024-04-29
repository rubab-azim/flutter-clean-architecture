import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/usecases/create_user_usecase.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/usecases/get_user_usecase.dart';
import 'package:flutter_clean_architecture/src/authentication/presentation/cubit/cubit/authentication_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateUser extends Mock implements CreateUser {}

class MockGetusers extends Mock implements GetUsers {}

void main() {
  late MockCreateUser createUser;
  late MockGetusers getUsers;
  late AuthenticationCubit cubit;
  const tCreateUserParams = CreateUserParams.empty();
  const tAPIFaliure = APIFailure(message: 'message', statusCode: 400);

  setUp(() {
    createUser = MockCreateUser();
    getUsers = MockGetusers();
    cubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });
  tearDown(() => cubit.close());

  test('Initial state should be [AuthenticationInitial]', () async {
    expect(cubit.state, const AuthenticationInitial());
  });

  group('create user', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [creating user, userCreated] when successfull',
      build: () {
        when(() => createUser(tCreateUserParams))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),
      expect: () => const [
        CreatingUser(),
        UserCreated(),
      ],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [creating user, AutheticationError] when unsuccessfull',
      build: () {
        when(() => createUser(any()))
            .thenAnswer((_) async => const Left(tAPIFaliure));
        return cubit;
      },
      act: (cubit) {
        cubit.createUser(
            createdAt: tCreateUserParams.createdAt,
            name: tCreateUserParams.name,
            avatar: tCreateUserParams.avatar);
      },
      expect: () => [
        const CreatingUser(),
        AuthenticationError(tAPIFaliure.errorMessage),
      ],
      verify: (bloc) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  group('get users', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [gettingUsers, UserLoaded] when successfull',
      build: () {
        when(
          () => getUsers(),
        ).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.getUser(),
      expect: () => [
        const GettingUser(),
        const UserLoaded([]),
      ],
      verify: (bloc) {
        verify(
          () => getUsers(),
        ).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [gettingUsers, AuthenticationError] when unSuccessfull',
      build: () {
        when(
          () => getUsers(),
        ).thenAnswer((_) async => left(tAPIFaliure));
        return cubit;
      },
      act: (cubit) {
        cubit.getUser();
      },
      expect: () => [
        const GettingUser(),
        AuthenticationError(tAPIFaliure.errorMessage),
      ],
      verify: (bloc) {
        verify(
          () => getUsers(),
        ).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}

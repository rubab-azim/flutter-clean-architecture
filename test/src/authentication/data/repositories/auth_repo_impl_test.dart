import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/error/api_exception.dart';
import 'package:flutter_clean_architecture/core/error/failure.dart';
import 'package:flutter_clean_architecture/src/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_clean_architecture/src/authentication/data/model/user_model.dart';
import 'package:flutter_clean_architecture/src/authentication/data/repositories/auth_repo_impl.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late MockAuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;
  setUp(() {
    remoteDataSource = MockAuthenticationRemoteDataSource();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });
  const createdAt = 'whatever.CreatedAt';
  const name = 'whatever.Name';
  const avatar = 'whatever.avatar';
  group('createUser', () {
    const tException =
        APIException(message: "Unknow Error Occurred", statusCode: 500);
    test(
        'should call [RemoteDataSource.createUser] and complete'
        'successfully when the call to the remote source is successfull',
        () async {
      //arrange
      when(() => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          )).thenAnswer((_) async => Future.value());

      //act
      final result = await repoImpl.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
      //assert
      expect(result, equals(const Right(null)));
      verify(() => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          )).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should return [APIFailure]  when the call to the remote source'
        ' is unsuccessfull', () async {
      //arrange
      when(() => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          )).thenThrow(tException);

      //act
      final result = await repoImpl.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
      //assert
      expect(
        result,
        equals(
          Left(
            APIFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        ),
      );
      verify(() => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          )).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
  group(
    'getUsers',
    () {
      const tException =
          APIException(message: "Unknow Error Occurred", statusCode: 500);
      test(
          'should call [RemoteDataSource.getUsers] and return [List<User>]'
          'when call to remote source is successfull', () async {
        //arrange
        const exceptedUser = [UserModel.empty()];
        when(() => remoteDataSource.getUsers())
            .thenAnswer((_) async => exceptedUser);

        //act
        final result = await repoImpl.getUsers();
        //assert
        expect(result, isA<Right<dynamic, List<User>>>());
        verify(() => remoteDataSource.getUsers()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      });

      test(
        'should return [APIFailure]  when the call to the remote source'
        ' is unsuccessfull',
        () async {
          //Arrange
          when(() => remoteDataSource.getUsers()).thenThrow(tException);

          //Act
          final result = await repoImpl.getUsers();
          //Assert
          expect(result, equals(Left(APIFailure.fromException(tException))));
          verify(() => remoteDataSource.getUsers()).called(1);
          verifyNoMoreInteractions(remoteDataSource);
        },
      );
    },
  );
}

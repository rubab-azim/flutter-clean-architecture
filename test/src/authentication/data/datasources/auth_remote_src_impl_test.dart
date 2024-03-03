import 'dart:convert';

import 'package:flutter_clean_architecture/core/error/api_exception.dart';
import 'package:flutter_clean_architecture/core/utils/constant.dart';
import 'package:flutter_clean_architecture/src/authentication/data/datasources/auth_remote_src_impl.dart';
import 'package:flutter_clean_architecture/src/authentication/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client httpClient;
  late AuthenticationRemoteDataSrcImpl authenticationRemoteDataSrcImpl;

  setUp(() {
    httpClient = MockClient();
    authenticationRemoteDataSrcImpl =
        AuthenticationRemoteDataSrcImpl(httpClient);
    registerFallbackValue(Uri());
  });

  group('createUser', () {
    test('should complete successfuly when staus code is 200 or 201', () async {
      when(() => httpClient.post(any(), body: any(named: 'body'))).thenAnswer(
        (_) async => http.Response('User created successfully', 201),
      );

      final methodCall = authenticationRemoteDataSrcImpl.createUser;

      expect(
          methodCall(
            createdAt: 'createdAt',
            name: 'name',
            avatar: 'avatar',
          ),
          completes);
      verify(
        () => httpClient.post(Uri.https(kBaseUrl, kCreateUserEndPoint),
            body: jsonEncode({
              'createdAt': 'createdAt',
              'name': 'name',
              'avatar': 'avatar',
            })),
      ).called(1);
      verifyNoMoreInteractions(httpClient);
    });

    test(
      'should throws an [APIException] when the status code is not 200 or 201',
      () async {
        when(() => httpClient.post(any(), body: any(named: 'body'))).thenAnswer(
          (_) async => http.Response('Invalid email address', 400),
        );
        final methodCall = authenticationRemoteDataSrcImpl.createUser;

        expect(
          () => methodCall(
            createdAt: 'createdAt',
            name: 'name',
            avatar: 'avatar',
          ),
          throwsA(
            const APIException(
                message: 'Invalid email address', statusCode: 400),
          ),
        );
        verify(
          () => httpClient.post(Uri.https(kBaseUrl, kCreateUserEndPoint),
              body: jsonEncode({
                'createdAt': 'createdAt',
                'name': 'name',
                'avatar': 'avatar',
              })),
        ).called(1);
        verifyNoMoreInteractions(httpClient);
      },
    );
  });

  group('getUser', () {
    test('should return [List<Users>] when the status code is 200 ', () async {
//Arrange
      final tUsers = [const UserModel.empty()];
      when(
        () => httpClient.get(any()),
      ).thenAnswer(
          (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200));
//Act
      final result = await authenticationRemoteDataSrcImpl.getUsers();

//Assert
      expect(result, equals(tUsers));
      verify(() => httpClient.get(Uri.https(kBaseUrl, kGetUsers))).called(1);
      verifyNoMoreInteractions(httpClient);
    });
    test('should return [APIEXception] when status code is not 200', () async {
      //Arrange
      when(
        () => httpClient.get(any()),
      ).thenAnswer(
        (_) async => http.Response(
            'Mayday! Mayday! Mayday! Server down ,'
            'I repeat server is down, I repeat server is down'
            'AHHHHHHHHHHHHHHHHHHHH',
            500),
      );
      //Act
      final methodCall = authenticationRemoteDataSrcImpl.getUsers;
      //Assert
      expect(
        () => methodCall(),
        throwsA(
          const APIException(
              message: 'Mayday! Mayday! Mayday! Server down ,'
                  'I repeat server is down, I repeat server is down'
                  'AHHHHHHHHHHHHHHHHHHHH',
              statusCode: 500),
        ),
      );

      verify(
        () => httpClient.get(Uri.https(kBaseUrl, kGetUsers)),
      ).called(1);
      verifyNoMoreInteractions(httpClient);
    });
  });
}

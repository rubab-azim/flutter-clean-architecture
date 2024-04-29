import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/error/api_exception.dart';
import 'package:flutter_clean_architecture/core/utils/constant.dart';
import 'package:flutter_clean_architecture/core/utils/typedef.dart';
import 'package:flutter_clean_architecture/src/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_clean_architecture/src/authentication/data/model/user_model.dart';
import 'package:http/http.dart' as http;

class AuthenticationRemoteDataSrcImpl
    implements AuthenticationRemoteDataSource {
  AuthenticationRemoteDataSrcImpl(this._httpClient);
  final http.Client _httpClient;

  @override
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    try {
      final response =
          await _httpClient.post(Uri.https(kBaseUrl, kCreateUserEndPoint),
              body: jsonEncode({
                'createdAt': createdAt,
                'name': name,
                // 'avatar': avatar,
              }),
              headers: {'Content-Type': 'application/json'});
      debugPrint(Uri.https(kBaseUrl, kCreateUserEndPoint).toString());
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw const APIException(
            message: 'Invalid email address', statusCode: 400);
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final response =
        await _httpClient.get(Uri.https(kBaseUrl, kGetUsersEndPoint));
    try {
      if (response.statusCode != 200) {
        throw APIException(
            message: response.body, statusCode: response.statusCode);
      } else {
        return List<DataMap>.from(jsonDecode(response.body) as List)
            .map((map) => UserModel.fromMap(map))
            .toList();
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }
}

import 'dart:convert';

import 'package:flutter_clean_architecture/core/utils/typedef.dart';
import 'package:flutter_clean_architecture/src/authentication/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();
  test('should have subclass of [User] Entity', () {
    expect(tModel, isA<User>());
  });

  final tJson = fixture("user.json");
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test("Should return user model with the right data", () {
      final result = UserModel.fromMap(tMap);
      expect(result, equals(tModel));
    });
  });

  group('fromJson', () {
    test("Should return user model with the right data", () {
      final result = UserModel.fromJson(tJson);
      expect(result, equals(tModel));
    });
  });

  group('toMap', () {
    test("Should return a [Map] with the right data", () {
      final result = tModel.toMap();
      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test("Should return a [JSON]  String with the right data", () {
      final result = tModel.toJson();
      expect(result, equals(tJson));
    });
  });
}

import 'package:flutter_clean_architecture/src/authentication/data/model/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/entities/user.dart';

void main() {
  const tModel = UserModel.empty();
  test('should have subclass of [User] Entity', () {
    expect(tModel, isA<User>());
  });

  group('fromMap', () {
    test("to json", () {});
  });
}

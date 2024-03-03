import 'package:flutter_clean_architecture/src/authentication/data/model/user_model.dart';

abstract class AuthenticationRemoteDataSource {
  // they throw us exception with there is the probelem.
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

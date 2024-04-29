import 'package:flutter_clean_architecture/src/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_clean_architecture/src/authentication/data/datasources/auth_remote_src_impl.dart';
import 'package:flutter_clean_architecture/src/authentication/data/repositories/auth_repo_impl.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/repositories/auth_repo.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/usecases/create_user_usecase.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/usecases/get_user_usecase.dart';
import 'package:flutter_clean_architecture/src/authentication/presentation/cubit/cubit/authentication_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerFactory(
        () => AuthenticationCubit(createUser: sl(), getUsers: sl()))
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(sl()))
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthenticationRemoteDataSrcImpl(sl()))
    ..registerLazySingleton(() => http.Client());
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/entities/user.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/usecases/create_user_usecase.dart';
import 'package:flutter_clean_architecture/src/authentication/domain/usecases/get_user_usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required CreateUser createUser,
    required GetUsers getUsers,
  })  : _createUser = createUser,
        _getUsers = getUsers,
        super(AuthenticationInitial()) {
    on<CreateUserEvent>(_createUserHandler);
    on<GetUserEvent>(_getUserHandler);
  }
  final CreateUser _createUser;
  final GetUsers _getUsers;

  Future<void> _createUserHandler(
    CreateUserEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const CreatingUser());
    final result = await _createUser(CreateUserParams(
      createdAt: event.createdAt,
      name: event.name,
      avatar: event.avatar,
    ));

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (_) => emit(const UserCreated()),
    );
  }

  Future<void> _getUserHandler(
      GetUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(const GettingUser());
    final result = await _getUsers();
    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (users) => emit(UserLoaded(users)),
    );
  }
}

part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();
}

final class CreatingUser extends AuthenticationState {
  const CreatingUser();
}

final class GettingUser extends AuthenticationState {
  const GettingUser();
}

final class UserCreated extends AuthenticationState {
  const UserCreated();
}

final class UserLoaded extends AuthenticationState {
  const UserLoaded(this.users);
  final List<User> users;
  @override
  List<Object> get props => users.map((user) => user.id).toList();
}

final class AuthenticationError extends AuthenticationState {
  const AuthenticationError(this.message);
  final String message;
  @override
  List<String> get props => [message];
}

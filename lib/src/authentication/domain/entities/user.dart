import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(
      {required this.id,
      required this.createdAt,
      required this.name,
      required this.avatar});

  const User.empty()
      : this(id: 1, createdAt: " _createdAt", name: "_name", avatar: "_avatar");

  final int id;
  final String createdAt;
  final String name;
  final String avatar;

  // @override
  // bool operator ==(other) {
  //   return identical(other, this) ||
  //       other is User && other.runtimeType == runtimeType && other.id == id;
  // }

  // @override
  // int get hashCode => id.hashCode ^ name.hashCode;

  @override
  List<Object?> get props => [id];
}

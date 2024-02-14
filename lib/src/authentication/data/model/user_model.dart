import 'dart:convert';

import 'package:flutter_clean_architecture/src/authentication/domain/entities/user.dart';

import '../../../../core/utils/typedef.dart';

class UserModel extends User {
  const UserModel(
      {required super.id,
      required super.createdAt,
      required super.name,
      required super.avatar});

/* Since All feild are final in User entitiy and we cannot updaet those field so
if we want to update any of feild we will implement this function what it will 
dose it take any of the value that user want to update cause all feilds are 
null bale and dit create new user and return that user with udated value if any
value is null it will return the previous value of user.
*/
  const UserModel.empty()
      : this(id: 1, createdAt: " _createdAt", name: "_name", avatar: "_avatar");

  UserModel copyWith(
          {int? id, String? createdAt, String? name, String? avatar}) =>
      UserModel(
          id: id ?? this.id,
          createdAt: createdAt ?? this.createdAt,
          name: name ?? this.name,
          avatar: avatar ?? this.avatar);

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap map)
      : this(
            id: map['id'] as int,
            createdAt: map['createdAt'] as String,
            name: map['name'] as String,
            avatar: map['avatar'] as String);

  DataMap toMap() =>
      {'id': id, 'createdAt': createdAt, "name": name, "avatar": avatar};

  String toJson() => jsonEncode(toMap());

  @override
  bool get stringify => true;
}

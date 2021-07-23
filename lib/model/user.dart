import 'package:flutter/cupertino.dart';

@immutable
class UserId {
  final String id;
  UserId({required this.id});
}

@immutable
class UserName {
  final String value;
  UserName({required this.value});
}

@immutable
class UserIconImage {
  final String value;
  UserIconImage({required this.value});
}

class User {
  final UserId userId;
  final UserName userName;
  final UserIconImage? userIconImage;
  User({required this.userId, required this.userName, this.userIconImage});
}

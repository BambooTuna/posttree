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
  final UserIconImage userIconImage;
  User(
      {required this.userId,
      required this.userName,
      required this.userIconImage});
}

User defaultUser() {
  return User(
      userId: UserId(id: ""),
      userName: UserName(value: ""),
      userIconImage: UserIconImage(
          value:
              "https://1.bp.blogspot.com/-4tNnDdIsRL4/XSGFxRFKjEI/AAAAAAABTj4/6mcXrJTACacR4w6EkFS6jXb7u2OrG6NwQCLcBGAs/s800/sagi_denwa_oldman.png"));
}

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
  DateTime createdAt = DateTime.now();
  User(this.createdAt,
      {required this.userId,
      required this.userName,
      required this.userIconImage});

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId.id,
      'display_name': userName.value,
      'photo_url': userIconImage.value,
      'created_at': createdAt.toString(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is User) {
      return this.runtimeType == other.runtimeType &&
          this.userId.id == other.userId.id;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => super.hashCode;
}

User defaultUser() {
  return User(DateTime.now(),
      userId: UserId(id: ""),
      userName: UserName(value: ""),
      userIconImage: UserIconImage(
          value:
              "https://1.bp.blogspot.com/-4tNnDdIsRL4/XSGFxRFKjEI/AAAAAAABTj4/6mcXrJTACacR4w6EkFS6jXb7u2OrG6NwQCLcBGAs/s800/sagi_denwa_oldman.png"));
}

import 'package:flutter/cupertino.dart';

User newUser(Map<String, dynamic> document) {
  return User(
      DateTime.parse(document['created_at']),
      userId: document['user_id'],
      // document['display_name']
      userName: '匿名さん',
      userIconImage: document['photo_url']
  );
}

class User {
  final String userId;
  final String userName;
  final String userIconImage;
  DateTime createdAt = DateTime.now();
  User(this.createdAt,
      {required this.userId,
      required this.userName,
      required this.userIconImage});

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'display_name': userName,
      'photo_url': userIconImage,
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
          this.userId == other.userId;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => super.hashCode;
}

User defaultUser() {
  return User(DateTime.now(),
      userId: "",
      userName: "",
      userIconImage: "https://1.bp.blogspot.com/-4tNnDdIsRL4/XSGFxRFKjEI/AAAAAAABTj4/6mcXrJTACacR4w6EkFS6jXb7u2OrG6NwQCLcBGAs/s800/sagi_denwa_oldman.png");
}

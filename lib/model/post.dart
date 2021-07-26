import 'package:posttree/model/user.dart';

class Post {
  final String id;
  final User user;
  final String message;
  final bool isMine;
  DateTime createdAt = DateTime.now();
  Post(this.createdAt,
      {required this.id,
      required this.user,
      required this.message,
      required this.isMine});

  Map<String, dynamic> toMap() {
    return {
      'post_id': id,
      'author_id': user.userId.id,
      'content': message,
      'created_at': createdAt.toString(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Post) {
      return this.runtimeType == other.runtimeType && this.id == other.id;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => super.hashCode;
}

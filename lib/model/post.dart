import 'package:posttree/model/user.dart';

Post newPost(Map<String, dynamic> document) {
  return Post(DateTime.parse(document['created_at']),
      id: document['post_id'],
      user: newUser(document['author']),
      message: document['content']);
}

class Post {
  final String id;
  final User user;
  final String message;
  DateTime createdAt = DateTime.now();
  Post(this.createdAt,
      {required this.id, required this.user, required this.message});

  Map<String, dynamic> toMap() {
    return {
      'post_id': id,
      'author': user.toMap(),
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

Post emptyPost(String id) {
  return Post(
    DateTime.now(),
    id: id,
    user: defaultUser(),
    message: '',
  );
}

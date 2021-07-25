import 'package:posttree/model/user.dart';

class Post {
  final String id;
  final User user;
  final String message;
  final bool isMine;
  Post(
      {required this.id,
      required this.user,
      required this.message,
      required this.isMine});

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

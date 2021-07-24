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
}

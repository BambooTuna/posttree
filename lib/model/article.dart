import 'package:posttree/model/user.dart';
import 'package:posttree/model/post.dart';

class Article {
  final String id;
  final User author;
  final Set<Post> posts;
  Article({required this.id, required this.author, required this.posts});

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

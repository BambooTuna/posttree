import 'package:posttree/model/user.dart';
import 'package:posttree/model/post.dart';


Article newArticle(Map<String, dynamic> document) {
  return Article(
      DateTime.parse(document['created_at']),
      id: document['article_id'],
      author: newUser(document['author']),
      posts: (document['posts'] as List<dynamic>).map((e) => newPost(e as Map<String, dynamic>)).toSet()
  );
}

class Article {
  final String id;
  final User author;
  final Set<Post> posts;
  DateTime createdAt = DateTime.now();

  Article(this.createdAt, {required this.id, required this.author, required this.posts});

  Map<String, dynamic> toMap() {
    return {
      'article_id': id,
      'posts': posts.map((e) => e.toMap()).toList(),
      'author': author.toMap(),
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

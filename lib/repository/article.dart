import 'package:posttree/model/article.dart';
import 'package:posttree/model/post.dart';

abstract class ArticleRepository {
  Future<Article> findById(String id);
  Future<List<Article>> batchGetByAuthorId(String id);
}

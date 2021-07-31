import 'package:flutter/cupertino.dart';
import 'package:posttree/model/article.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/repository/article.dart';
import 'package:posttree/repository/post.dart';
import 'package:posttree/utils/random.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class PostTableViewModel extends ChangeNotifier {
  List<Post> _items = [];
  List<Post> get items => _items;

  Future<void> load(String userId);

  @override
  void dispose() {
    // streamを必ず閉じる
    super.dispose();
  }
}

final userPostTableViewModelProvider = ChangeNotifierProvider(
      (ref) => UserPostTableViewModel(postRepository: ref.read(postRepositoryProvider)),
);

class UserPostTableViewModel extends PostTableViewModel {
  PostRepository postRepository;
  UserPostTableViewModel({required this.postRepository});

  @override
  Future<void> load(String userId) async {
    final posts = await postRepository.batchGetByAuthorId(userId);
    this._items = posts;
    notifyListeners();
  }
}

final articleTableViewModelProvider = ChangeNotifierProvider(
      (ref) => ArticleTableViewModel(
      articleRepository: ref.read(articleRepositoryProvider)
  ),
);

class ArticleTableViewModel extends ChangeNotifier {
  final ArticleRepository articleRepository;
  ArticleTableViewModel({required this.articleRepository});

  List<Article> _items = [];
  List<Article> get items => _items;

  Future<void> load(String userId) async {
    final articles = await articleRepository.batchGetByAuthorId(userId);
    this._items = articles;
    notifyListeners();
  }

  @override
  void dispose() {
    // streamを必ず閉じる
    super.dispose();
  }
}

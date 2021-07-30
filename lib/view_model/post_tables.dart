import 'package:flutter/cupertino.dart';
import 'package:posttree/model/article.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/repository/article.dart';
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

class UserPostTableViewModel extends PostTableViewModel {
  @override
  Future<void> load(String userId) async {
    await Future.delayed(Duration(seconds: 1));
    this._items.insert(
        0,
        Post(DateTime.now(),
            id: randomString(10),
            message: randomString(50),
            user: User(DateTime.now(),
                userId: userId,
                userName: "未実装",
                userIconImage: "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg")));
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

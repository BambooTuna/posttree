import 'dart:async';
import 'package:posttree/model/article.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/repository/article.dart';
import 'package:posttree/repository/post.dart';
import 'package:posttree/utils/event.dart';

import 'package:flutter/material.dart';
import 'package:posttree/model/account.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/repository/account.dart';
import 'package:posttree/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posttree/utils/random.dart';

final homeViewModelProvider = ChangeNotifierProvider(
  (ref) => HomeViewModel(
    accountRepository: ref.read(accountRepositoryProvider),
    postRepository: ref.read(postRepositoryProvider),
    articleRepository: ref.read(articleRepositoryProvider)
  ),
);

class HomeViewModel extends ChangeNotifier {
  // Static
  final AccountRepository accountRepository;
  final PostRepository postRepository;
  final ArticleRepository articleRepository;

  HomeViewModel(
      {required this.accountRepository, required this.postRepository, required this.articleRepository});

  // Stream
  var _voidEventAction = StreamController<Event>.broadcast();
  StreamController<Event> get voidEventAction => _voidEventAction;

  // Getter / Setter
  User? _selfUser;
  User? get selfUser => _selfUser;
  bool get isLogin => _selfUser != null;

  List<Post> _timelineItems = [];
  List<Post> get timelineItems => _timelineItems;

  // Function
  Future<void> post(String message) async {
    try {
      if (this._selfUser != null) {
        await postRepository.insert(Post(DateTime.now(),
            id: randomString(10),
            message: message,
            user: _selfUser!));
      }
      _voidEventAction.sink.add(EventSuccess());
    } catch (e) {
      logger.warning('Exception: ${e.toString()}');
      _voidEventAction.sink.add(EventFailed());
    } finally {
      notifyListeners();
    }
  }

  Future<Article> summarize(String title, Set<Post> posts) async {
    final article = Article(
        DateTime.now(),
        id: randomString(10),
        author: this._selfUser!,
        title: title,
        posts: posts
    );
    await articleRepository.insert(article);
    return article;
  }

  Future<void> refreshSelf() async {
    try {
      final user =
          await accountRepository.verifyUser(ServiceId(id: "posttree"));
      this._selfUser = user;
      _voidEventAction.sink.add(EventSuccess());
    } catch (e) {
      this._selfUser = null;
      logger.warning('Exception: ${e.toString()}');
      _voidEventAction.sink.add(EventFailed());
    } finally {
      notifyListeners();
    }
  }

  Future<void> refreshTimeline() async {
    try {
      final posts = await postRepository.searchLatest(30);
      this._timelineItems = posts;
      _voidEventAction.sink.add(EventSuccess());
    } catch (e) {
      logger.warning('Exception: ${e.toString()}');
      _voidEventAction.sink.add(EventFailed());
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // streamを必ず閉じる
    _voidEventAction.close();
    super.dispose();
  }
}

import 'dart:async';
import 'package:posttree/model/article.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/repository/article.dart';
import 'package:posttree/repository/post.dart';
import 'package:posttree/utils/event.dart';

import 'package:flutter/material.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posttree/utils/random.dart';

final homeViewModelProvider = ChangeNotifierProvider(
  (ref) => HomeViewModel(
    postRepository: ref.read(postRepositoryProvider),
    articleRepository: ref.read(articleRepositoryProvider)
  ),
);

class HomeViewModel extends ChangeNotifier {
  // Static
  final PostRepository postRepository;
  final ArticleRepository articleRepository;

  HomeViewModel(
      {required this.postRepository, required this.articleRepository});

  // Stream
  var _voidEventAction = StreamController<Event>.broadcast();
  StreamController<Event> get voidEventAction => _voidEventAction;

  // Getter / Setter
  List<Post> _timelineItems = [];
  List<Post> get timelineItems => _timelineItems;

  // Function
  Future<void> post(User? user, String message) async {
    try {
      if (user != null) {
        await postRepository.insert(Post(DateTime.now(),
            id: randomString(10),
            message: message,
            user: user));
      }
      _voidEventAction.sink.add(EventSuccess());
    } catch (e) {
      logger.warning('Exception: ${e.toString()}');
      _voidEventAction.sink.add(EventFailed());
    } finally {
      notifyListeners();
    }
  }

  Future<Article> summarize(User? user, String title, Set<Post> posts) async {
    final article = Article(
        DateTime.now(),
        id: randomString(10),
        author: user!,
        title: title,
        posts: posts
    );
    await articleRepository.insert(article);
    return article;
  }

  Future<void> refreshTimeline(User? user) async {
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

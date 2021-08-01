import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:posttree/model/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posttree/view_model/home.dart';
import 'package:posttree/model/user.dart';

import 'article.dart';

final postCartProvider = ChangeNotifierProvider(
  (ref) => PostCart(
    homeViewModel: ref.read(homeViewModelProvider),
  ),
);

class PostCart extends ChangeNotifier {
  final HomeViewModel homeViewModel;
  PostCart({required this.homeViewModel});

  Set<Post> _items = {};
  Set<Post> get items => _items;
  int get count => _items.length;
  bool _editMode = false;
  bool get editMode => _editMode;

  bool exist(Post item) {
    return _items.contains(item);
  }

  var _createArticleAction = StreamController<Article>();
  StreamController<Article> get createArticleAction => _createArticleAction;

  switchToEditMode() {
    if (this._editMode) {
      return;
    }
    this._editMode = true;
    notifyListeners();
  }

  add(Post item) {
    this._items.add(item);
    notifyListeners();
  }

  del(Post item) {
    this._items.remove(item);
    notifyListeners();
  }

  summarize(User? user, String title) async {
    if (!this._editMode) {
      return;
    }
    if (this._items.isNotEmpty) {
      final article =
          await homeViewModel.summarize(user, title, {...this._items});
      _createArticleAction.sink.add(article);
    }
    this._editMode = false;
    this._items.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _createArticleAction.close();
    super.dispose();
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/utils/random.dart';

import 'article.dart';

class PostCart extends ChangeNotifier {
  Set<Post> _items = {};
  Set<Post> get items => _items;
  int get count => _items.length;

  bool _editMode = false;
  bool get editMode => _editMode;

  bool exist(Post item) {
    print(_items.contains(item));
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

  summarize() {
    if (!this._editMode) {
      return;
    }
    _createArticleAction.sink.add(Article(
        id: randomString(10), author: defaultUser(), posts: {...this._items}));
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

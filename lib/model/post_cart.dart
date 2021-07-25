import 'package:flutter/cupertino.dart';
import 'package:posttree/model/post.dart';

class PostCart extends ChangeNotifier {
  Set<Post> _items = {};
  Set<Post> get items => _items;
  int get count => _items.length;
  // bool get exist => _items.contains(_items);

  bool _editMode = false;
  bool get editMode => _editMode;

  bool exist(Post item) {
    print(_items.contains(item));
    return _items.contains(item);
  }

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
    print(this._items);
    this._editMode = false;
    this._items.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

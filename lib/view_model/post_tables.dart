import 'package:flutter/cupertino.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/utils/random.dart';

abstract class PostTableViewModel extends ChangeNotifier {
  List<Post> _items = [];
  List<Post> get items => _items;

  bool _editMode = false;
  bool get editMode => _editMode;

  void toEditMode() {
    if (this.editMode) {
      return;
    }
    this._editMode = true;
    notifyListeners();
  }

  void toNormalMode() {
    if (!this.editMode) {
      return;
    }
    this._editMode = false;
    notifyListeners();
  }

  Future<void> load(UserId userId);

  @override
  void dispose() {
    // streamを必ず閉じる
    super.dispose();
  }
}

class TimelinePostTableViewModel extends PostTableViewModel {
  @override
  Future<void> load(UserId userId) async {
    await Future.delayed(Duration(seconds: 1));
    this._items.insert(
        0,
        Post(
            id: randomString(10),
            message: randomString(50),
            user: User(
                userId: UserId(id: randomString(10)),
                userName: UserName(value: randomString(5)),
                userIconImage: UserIconImage(
                    value:
                        "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg")),
            isMine: false));
    notifyListeners();
  }
}

class UserPostTableViewModel extends PostTableViewModel {
  @override
  Future<void> load(UserId userId) async {
    await Future.delayed(Duration(seconds: 1));
    this._items.insert(
        0,
        Post(
            id: randomString(10),
            message: randomString(50),
            user: User(
                userId: UserId(id: userId.id),
                userName: UserName(value: userId.id),
                userIconImage: UserIconImage(
                    value:
                        "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg")),
            isMine: false));
    notifyListeners();
  }
}

class DraftPostTableViewModel extends PostTableViewModel {
  @override
  Future<void> load(UserId userId) async {
    await Future.delayed(Duration(seconds: 1));
    notifyListeners();
  }
}

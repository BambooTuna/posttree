import 'package:flutter/cupertino.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/utils/random.dart';

class PostTableViewModel extends ChangeNotifier {
  List<Post> _items = [
    Post(
        message: randomString(100),
        user: User(
            userId: UserId(id: "userId"),
            userName: UserName(value: "userName"),
            userIconImage: UserIconImage(
                value:
                    "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg")),
        isMine: false),
    Post(
        message: "???",
        user: User(
            userId: UserId(id: "takeo"),
            userName: UserName(value: "たけちゃ"),
            userIconImage: UserIconImage(
                value:
                    "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg")),
        isMine: true)
  ];
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

  Future<void> reload() async {
    this._items.insert(
        0,
        Post(
            message: randomString(50),
            user: User(
                userId: UserId(id: randomString(10)),
                userName: UserName(value: randomString(5)),
                userIconImage: UserIconImage(
                    value:
                        "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg")),
            isMine: false));

    await Future.delayed(Duration(seconds: 1));
    notifyListeners();
  }

  @override
  void dispose() {
    // streamを必ず閉じる
    super.dispose();
  }
}

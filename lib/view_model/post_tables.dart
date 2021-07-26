import 'package:flutter/cupertino.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/utils/random.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class PostTableViewModel extends ChangeNotifier {
  List<Post> _items = [];
  List<Post> get items => _items;

  Future<void> load(UserId userId);

  @override
  void dispose() {
    // streamを必ず閉じる
    super.dispose();
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

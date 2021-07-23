import 'package:flutter/cupertino.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/model/user.dart';

class PostTableViewModel extends ChangeNotifier {
  List<Post> _items = [
    Post(
        message:
            "messagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessage",
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
        isMine: true),
    Post(
        message:
            "messagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessage",
        user: User(
            userId: UserId(id: "userId2"),
            userName: UserName(value: "><"),
            userIconImage: UserIconImage(
                value:
                    "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg")),
        isMine: false),
    Post(
        message:
            "messagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessage",
        user: User(
            userId: UserId(id: "userId"),
            userName: UserName(value: "アレクサ"),
            userIconImage: UserIconImage(
                value:
                    "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg")),
        isMine: false),
    Post(
        message:
            "messagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessagemessage",
        user: User(
            userId: UserId(id: "userId"),
            userName: UserName(value: "山田"),
            userIconImage: UserIconImage(
                value:
                    "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg")),
        isMine: false)
  ];
  List<Post> get items => _items;

  Future<void> reload() async {
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void dispose() {
    // streamを必ず閉じる
    super.dispose();
  }
}

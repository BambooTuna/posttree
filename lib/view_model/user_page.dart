import 'dart:async';
import 'package:flutter/material.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/utils/random.dart';

class UserPageViewModel extends ChangeNotifier {
  UserPageViewModel({required this.userId});

  var _eventAction = StreamController<Event>();
  StreamController<Event> get eventAction => _eventAction;

  final UserId userId;
  User? _user;
  User? get user => _user;

  List<Post> _items = [
    Post(
        message:
        randomString(100),
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

  Future<void> reload() async {
    await Future.delayed(Duration(seconds: 1));
    // TODO get user profile
    final user = User(
        userId: this.userId,
        userName: UserName(value: "たけちゃ"),
        userIconImage: UserIconImage(
            value:
                "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg"));
    this._user = user;

    this._items.insert(0, Post(
        message:
        randomString(50),
        user: User(
            userId: UserId(id: randomString(10)),
            userName: UserName(value: randomString(5)),
            userIconImage: UserIconImage(
                value:
                "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg")),
        isMine: false));

    _eventAction.sink.add(EventSuccess());
    notifyListeners();
  }

  @override
  void dispose() {
    // streamを必ず閉じる
    _eventAction.close();
    super.dispose();
  }
}

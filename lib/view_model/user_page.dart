import 'dart:async';
import 'package:flutter/material.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/utils/event.dart';

class UserPageViewModel extends ChangeNotifier {
  var _eventAction = StreamController<Event>.broadcast();
  StreamController<Event> get eventAction => _eventAction;

  User? _user;
  User? get user => _user;

  Future<void> load(UserId userId) async {
    await Future.delayed(Duration(seconds: 1));
    // TODO get user profile
    final user = User(
        userId: userId,
        userName: UserName(value: "たけちゃ"),
        userIconImage: UserIconImage(
            value:
                "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg"));
    this._user = user;
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

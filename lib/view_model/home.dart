import 'package:flutter/material.dart';
import 'package:posttree/model/user.dart';

class HomeViewModel extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  User? _user;
  User get user => _user != null
      ? _user!
      : User(
          userId: UserId(id: "guest"),
          userName: UserName(value: "アレクサ"),
          userIconImage: UserIconImage(
              value:
                  "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg"));
  bool get isLogin => _user != null;

  void incrementCounter() {
    this._counter++;
    notifyListeners();
  }

  void setUser(User? user) {
    this._user = user;
    notifyListeners();
  }
}

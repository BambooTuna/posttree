import 'package:flutter/material.dart';
import 'package:posttree/model/user.dart';

class HomeViewModel extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  User? _user;
  User get user => _user != null
      ? _user!
      : User(userId: UserId(id: "guest"), userName: UserName(value: "アレクサ"));
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

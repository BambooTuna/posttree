import 'dart:async';
import 'package:flutter/material.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/repository/account.dart';
import 'package:posttree/utils/event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userPageViewModelProvider = ChangeNotifierProvider(
      (ref) => UserPageViewModel(accountRepository: ref.read(accountRepositoryProvider)),
);

class UserPageViewModel extends ChangeNotifier {
  AccountRepository accountRepository;
  UserPageViewModel({required this.accountRepository});

  var _eventAction = StreamController<Event>.broadcast();
  StreamController<Event> get eventAction => _eventAction;

  User? _user;
  User? get user => _user;

  Future<void> load(String userId) async {
    await Future.delayed(Duration(seconds: 1));
    final user = await accountRepository.findUserById(userId);
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:posttree/model/account.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/repository/account.dart';
import 'package:posttree/utils/state.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/utils/logger.dart';
import 'package:provider/provider.dart';

// ユーザーの認証と
class AuthenticateViewModel extends ChangeNotifier {
  final AccountRepository accountRepository;
  AuthenticateViewModel({required this.accountRepository});

  var _authenticateSuccessAction = StreamController<User?>();
  StreamController<User?> get authenticateSuccessAction =>
      _authenticateSuccessAction;

  Future<void> signIn() async {
    await accountRepository.signInWithGoogle();
    this.authenticate();
  }

  Future<void> authenticate() async {
    try {
      final userId =
          await accountRepository.verifyUser(ServiceId(id: "posttree"));
      // TODO fetch other user info
      final user = User(
          userId: userId!,
          userName: UserName(value: "たけちゃ"),
          userIconImage: UserIconImage(
              value:
                  "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg"));
      _authenticateSuccessAction.sink.add(user);
    } on Exception catch (e) {
      logger.warning('Other Exception');
      logger.warning('${e.toString()}');
      _authenticateSuccessAction.sink.add(null);
    } finally {
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await accountRepository.signOut();
    this.authenticate();
  }

  @override
  void dispose() {
    // streamを必ず閉じる
    _authenticateSuccessAction.close();
    super.dispose();
  }
}

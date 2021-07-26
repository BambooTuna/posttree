import 'dart:async';

import 'package:flutter/material.dart';
import 'package:posttree/repository/account.dart';
import 'package:posttree/utils/state.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewModelProvider = ChangeNotifierProvider(
  (ref) =>
      LoginViewModel(accountRepository: ref.read(accountRepositoryProvider)),
);

class LoginViewModel extends ChangeNotifier {
  // Static
  final AccountRepository accountRepository;
  LoginViewModel({required this.accountRepository});

  var _uiState = UiState.Idle;
  UiState get uiState => _uiState;
  bool get isLogging => uiState == UiState.Loading;

  var _loginEventAction = StreamController<Event>.broadcast();
  StreamController<Event> get loginEventAction => _loginEventAction;

  void signInWithGoogle() async {
    _uiState = UiState.Loading;
    notifyListeners();
    try {
      await accountRepository.signInWithGoogle();
      _loginEventAction.sink.add(EventSuccess());
    } catch (e) {
      logger.warning('Exception: ${e.toString()}');
      _loginEventAction.sink.add(EventFailed());
    } finally {
      _uiState = UiState.Loaded;
      notifyListeners();
    }
  }

  void signInWithTwitter() async {
    _uiState = UiState.Loading;
    notifyListeners();
    try {
      await accountRepository.signInWithTwitter();
      loginEventAction.sink.add(EventSuccess());
    } catch (e) {
      logger.warning('Exception: ${e.toString()}');
      loginEventAction.sink.add(EventFailed());
    } finally {
      _uiState = UiState.Loaded;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // streamを必ず閉じる
    _loginEventAction.close();
    super.dispose();
  }
}

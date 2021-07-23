import 'dart:async';

import 'package:flutter/material.dart';
import 'package:posttree/utils/state.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/utils/logger.dart';

import 'authenticate.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthenticateViewModel authenticateViewModel;
  LoginViewModel({required this.authenticateViewModel});

  var _uiState = UiState.Idle;
  UiState get uiState => _uiState;
  bool get isLogging => uiState == UiState.Loading;

  var _loginSuccessAction = StreamController<Event>();
  StreamController<Event> get loginSuccessAction => _loginSuccessAction;

  void login() async {
    _uiState = UiState.Loading;
    notifyListeners();
    try {
      await authenticateViewModel.signIn();
      _loginSuccessAction.sink.add(EventSuccess());
    } catch (e) {
      logger.warning('Exception');
      logger.warning('${e.toString()}');
      _loginSuccessAction.sink.add(EventFailed());
    } finally {
      _uiState = UiState.Loaded;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // streamを必ず閉じる
    _loginSuccessAction.close();
    super.dispose();
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posttree/const/login.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/utils/state.dart';

class PostFormViewModel extends ChangeNotifier {
  var _eventAction = StreamController<Event>.broadcast();
  StreamController<Event> get eventAction => _eventAction;

  String _content = "";
  String get content => _content;

  String? _errorMessage = "";
  String? get errorMessage => _errorMessage;

  var _uiState = UiState.Idle;
  UiState get uiState => _uiState;
  bool get isLogging => uiState == UiState.Loading;

  setContent(String text) {
    this._content = text;
    this.validation();
  }

  clear() {
    this._content = "";
  }

  validation() {
    if (this._content == "") {
      this._errorMessage = "何か入力してね！";
    } else {
      this._errorMessage = null;
    }
    notifyListeners();
  }

  send() async {
    if (_uiState == UiState.Loading) {
      return;
    }
    EasyLoading.show(status: loadingText);
    _uiState = UiState.Loading;
    notifyListeners();

    this.validation();
    if (this._errorMessage == null) {
      await Future.delayed(Duration(seconds: 1));
      // TODO: send _content to server
      _eventAction.sink.add(EventSuccess());
    } else {
      _eventAction.sink.add(EventFailed());
    }

    this.clear();
    _uiState = UiState.Loaded;
    notifyListeners();
  }

  @override
  void dispose() {
    // streamを必ず閉じる
    _eventAction.close();
    super.dispose();
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:posttree/const/login.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/utils/state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postFormViewModelProvider = ChangeNotifierProvider(
  (ref) => PostFormViewModel(),
);

class PostFormViewModel extends ChangeNotifier {
  var _eventAction = StreamController<Event>.broadcast();
  StreamController<Event> get eventAction => _eventAction;

  final _formKey = GlobalKey<FormBuilderState>();
  GlobalKey<FormBuilderState> get formKey => _formKey;

  Map<String, dynamic> _value = {};
  Map<String, dynamic> get initialValue => _value;

  var _uiState = UiState.Idle;
  UiState get uiState => _uiState;
  bool get isLogging => uiState == UiState.Loading;

  cacheValue() {
    if (_formKey.currentState?.value.isNotEmpty ?? false) {
      return;
    }
    _formKey.currentState?.save();
    _value = _formKey.currentState?.value ?? {};
  }

  clearCache() {
    _value = {};
  }

  resetState() {
    _formKey.currentState?.reset();
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  send() async {
    this.cacheValue();
    if (!this.validate()) {
      return;
    }

    if (_uiState == UiState.Loading) {
      return;
    }
    EasyLoading.show(status: loadingText);
    _uiState = UiState.Loading;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));
    // TODO: send _content to server
    _eventAction.sink.add(EventSuccess());

    this.clearCache();
    this.resetState();
    _uiState = UiState.Loaded;
    notifyListeners();

    EasyLoading.dismiss();
  }

  @override
  void dispose() {
    // streamを必ず閉じる
    _eventAction.close();
    super.dispose();
  }
}

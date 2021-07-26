import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:posttree/const/login.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/view_model/login.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          viewTitle,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: LoginBody(),
    );
  }
}

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  late StreamSubscription<Event> _subscription;

  @override
  void initState() {
    super.initState();

    var viewModel = context.read(loginViewModelProvider);
    _subscription = viewModel.loginEventAction.stream.listen((event) {
      EasyLoading.dismiss();
      switch (event.runtimeType) {
        case EventSuccess:
          Navigator.of(context).pop();
          break;
        case EventFailed:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _LoginButton(),
    );
  }

  @override
  void dispose() {
    // broadcast streamをlistenしている場合は毎回subscriptionを閉じないといけない
    _subscription.cancel();
    super.dispose();
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              SignInButton(
                Buttons.Google,
                text: signInWithGoogle,
                onPressed: () {
                  final viewModel = watch(loginViewModelProvider);
                  if (!viewModel.isLogging) {
                    viewModel.signInWithGoogle();
                    EasyLoading.show(status: loadingText);
                  }
                },
              ),
              Divider(),
              SignInButton(
                Buttons.Twitter,
                text: signInWithTwitter,
                onPressed: () {
                  final viewModel = watch(loginViewModelProvider);
                  if (!viewModel.isLogging) {
                    viewModel.signInWithTwitter();
                    EasyLoading.show(status: loadingText);
                  }
                },
              ),
            ]));
      },
    );
  }
}

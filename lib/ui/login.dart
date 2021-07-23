import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:posttree/const/login.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/view_model/authenticate.dart';
import 'package:posttree/view_model/login.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => LoginViewModel(
                authenticateViewModel: Provider.of<AuthenticateViewModel>(
                    context,
                    listen: false))),
      ],
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          viewTitle,
          style: Theme.of(context).primaryTextTheme.headline4,
        )),
        body: LoginBody(),
      ),
      builder: EasyLoading.init(),
    );
  }
}

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  @override
  void initState() {
    super.initState();

    var viewModel = Provider.of<LoginViewModel>(context, listen: false);
    viewModel.loginSuccessAction.stream.listen((event) {
      EasyLoading.dismiss();
      switch (event.runtimeType) {
        case EventSuccess:
          Navigator.of(context).pop();
          break;
        case EventFailed:
          Navigator.of(context).pushReplacementNamed("/login");
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
}

class _LoginButton extends StatelessWidget {
  VoidCallback _onPressed(LoginViewModel viewModel) {
    if (viewModel.isLogging) {
      return () {};
    } else {
      return () {
        viewModel.login();
        EasyLoading.show(status: loadingText);
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, _) {
        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              SignInButton(
                Buttons.Google,
                text: signInWithGoogle,
                onPressed: _onPressed(viewModel),
              ),
            ]));
      },
    );
  }
}

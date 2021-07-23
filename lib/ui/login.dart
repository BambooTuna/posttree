import 'package:flutter/material.dart';
import 'package:posttree/const/login.dart';
import 'package:posttree/repository/account.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/utils/logger.dart';
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
          loginViewTitle,
          style: Theme.of(context).primaryTextTheme.headline4,
        )),
        body: LoginBody(),
      ),
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
  String _getButtonText(LoginViewModel viewModel) =>
      viewModel.isLogging ? loggingButtonText : loginButtonText;

  VoidCallback? _onPressed(LoginViewModel viewModel) {
    if (viewModel.isLogging) {
      return null;
    } else {
      return () {
        viewModel.login();
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, _) {
        return ElevatedButton(
          child: Text(
            _getButtonText(viewModel),
            style: Theme.of(context).primaryTextTheme.button,
          ),
          onPressed: _onPressed(viewModel),
        );
      },
    );
  }
}

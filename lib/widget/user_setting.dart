import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:posttree/view_model/authenticate.dart';
import 'package:provider/provider.dart';

class UserSettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticateViewModel>(
      builder: (context, viewModel, _) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text("設定"),
              ),
              ListTile(
                title: Text("ログアウト"),
                onTap: () async {
                  await viewModel.signOut();
                  Navigator.of(context).popUntil(ModalRoute.withName("/home"));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

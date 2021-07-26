import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:posttree/repository/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read(accountRepositoryProvider);
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
  }
}

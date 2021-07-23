import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posttree/const/user_page.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/view_model/user_page.dart';
import 'package:provider/provider.dart';

class UserPageArguments {
  final String userId;
  UserPageArguments(this.userId);
}

class UserPage extends StatelessWidget {
  final UserId userId;
  UserPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => UserPageViewModel(userId: userId)),
      ],
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          viewTitle,
          style: Theme.of(context).primaryTextTheme.headline4,
        )),
        body: UserPageBody(),
      ),
      builder: EasyLoading.init(),
    );
  }
}

class UserPageBody extends StatefulWidget {
  @override
  _UserPageBodyState createState() => _UserPageBodyState();
}

class _UserPageBodyState extends State<UserPageBody> {
  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: loadingText);
    var viewModel = Provider.of<UserPageViewModel>(context, listen: false);
    viewModel.eventAction.stream.listen((event) {
      EasyLoading.dismiss();
      switch (event.runtimeType) {
        case EventSuccess:
          break;
        case EventFailed:
          Navigator.of(context).pop();
          break;
      }
    });
    viewModel.getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserPageViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.user == null) {
          return Container();
        } else {
          return Center(child: Text(viewModel.user!.userName.value));
        }
      },
    );
  }
}

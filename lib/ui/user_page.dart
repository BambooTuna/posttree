import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posttree/const/user_page.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/view_model/post_tables.dart';
import 'package:posttree/view_model/user_page.dart';
import 'package:posttree/widget/post_card.dart';
import 'package:posttree/widget/refreshable_post_table.dart';
import 'package:posttree/widget/tabbar.dart';
import 'package:posttree/widget/user_icon.dart';
import 'package:posttree/widget/user_setting.dart';
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
        ChangeNotifierProvider(
            create: (context) => UserPostTableViewModel(userId: userId)),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(userId.id),
          // backgroundColor: Colors.white.withOpacity(0.0),
          // elevation: 0.0,
          leading: Builder(
            builder: (BuildContext context) {
              final ScaffoldState? scaffold = Scaffold.maybeOf(context);
              final ModalRoute<Object?>? parentRoute = ModalRoute.of(context);
              final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
              final bool canPop = parentRoute?.canPop ?? false;
              if (hasEndDrawer && canPop) {
                return BackButton();
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
        // extendBodyBehindAppBar: true,
        body: UserPageBody(),
        endDrawer: UserSettingWidget(),
        // backgroundColor: Theme.of(context).backgroundColor,
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
    var userPageViewModel =
        Provider.of<UserPageViewModel>(context, listen: false);
    userPageViewModel.eventAction.stream.listen((event) {
      EasyLoading.dismiss();
      switch (event.runtimeType) {
        case EventSuccess:
          break;
        case EventFailed:
          Navigator.of(context).pop();
          break;
      }
    });
    userPageViewModel.reload();

    var userPostTableViewModel =
        Provider.of<UserPostTableViewModel>(context, listen: false);
    userPostTableViewModel.reload();
  }

  @override
  Widget build(BuildContext context) {
    var userPageViewModel = Provider.of<UserPageViewModel>(context);
    var userPostTableViewModel = Provider.of<UserPostTableViewModel>(context);

    var user = userPageViewModel.user ?? defaultUser();
    return Column(children: [
      UserIconWidget(
        iconSize: 200.0,
        radius: 80,
        onTap: () {},
        iconUrl: user.userIconImage.value,
      ),
      Expanded(
          child: TabBarWidget(tabs: [
        Tab(
          icon: Icon(
            Icons.paste,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        Tab(
          icon: Icon(
            Icons.edit,
            color: Theme.of(context).iconTheme.color,
          ),
        )
      ], children: [
        RefreshableItemTable(
          items: userPostTableViewModel.items
              .map((e) => PostCard(item: e))
              .toList(),
          onRefresh: userPostTableViewModel.reload,
        ),
        RefreshableItemTable(
          items: userPostTableViewModel.items
              .map((e) => PostCard(item: e))
              .toList(),
          onRefresh: userPostTableViewModel.reload,
        )
      ]))
    ]);
  }
}

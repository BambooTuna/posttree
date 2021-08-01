import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posttree/const/user_page.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/repository/article.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/view_model/post_tables.dart';
import 'package:posttree/view_model/user_page.dart';
import 'package:posttree/widget/post_card.dart';
import 'package:posttree/widget/article_card.dart';
import 'package:posttree/widget/refreshable_post_table.dart';
import 'package:posttree/widget/tabbar.dart';
import 'package:posttree/widget/user_icon.dart';
import 'package:posttree/widget/user_setting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home.dart';

class UserPageArguments {
  final String userId;
  UserPageArguments(this.userId);
}

class UserPage extends StatelessWidget {
  final String userId;
  UserPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(userId),
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
      body: UserPageBody(userId: this.userId),
      endDrawer: UserSettingWidget(),
      // backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}

class UserPageBody extends StatefulWidget {
  final String userId;
  UserPageBody({required this.userId});

  @override
  _UserPageBodyState createState() => _UserPageBodyState(userId: this.userId);
}

class _UserPageBodyState extends State<UserPageBody> {
  final String userId;
  _UserPageBodyState({required this.userId});

  late StreamSubscription<Event> _subscription;

  @override
  void initState() {
    super.initState();

    EasyLoading.show(status: loadingText);
    var userPageViewModel = context.read(userPageViewModelProvider);
    _subscription = userPageViewModel.eventAction.stream.listen((event) {
      EasyLoading.dismiss();
      switch (event.runtimeType) {
        case EventSuccess:
          break;
        case EventFailed:
          Navigator.of(context).pop();
          break;
      }
    });
    userPageViewModel.load(this.userId);

    var userPostTableViewModel = context.read(userPostTableViewModelProvider);
    userPostTableViewModel.load(this.userId);

    var articleTableViewModel = context.read(articleTableViewModelProvider);
    articleTableViewModel.load(this.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      var userPageViewModel = watch(userPageViewModelProvider);
      var userPostTableViewModel = watch(userPostTableViewModelProvider);
      var articleTableViewModel = watch(articleTableViewModelProvider);
      var user = userPageViewModel.user ?? defaultUser();
      return Column(children: [
        UserIconWidget(
          iconSize: 160.0,
          radius: 70,
          onTap: () {},
          iconUrl: user.userIconImage,
        ),
        SizedBox(height: 12),
        Text(
          user.userName,
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 24),
        Expanded(
            child: TabBarWidget(tabs: [
          Tab(
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.bookmarks,
              color: Theme.of(context).iconTheme.color,
            ),
          )
        ], children: [
          RefreshableItemTable(
            items: userPostTableViewModel.items
                .map((e) => PostCard(item: e))
                .toList(),
            onRefresh: () {
              return userPostTableViewModel.load(this.userId);
            },
            lastWidget: Center(
                child: Text(
              "投稿したものはここに表示されるよ",
              style: Theme.of(context).textTheme.bodyText1,
            )),
          ),
          RefreshableItemTable(
            items: articleTableViewModel.items
                .map((e) => ArticleCard(item: e))
                .toList(),
            onRefresh: () {
              return articleTableViewModel.load(this.userId);
            },
            lastWidget: Center(
                child: Text(
              "まとめた記事はここに表示されるよ",
              style: Theme.of(context).textTheme.bodyText1,
            )),
          )
        ]))
      ]);
    });
  }

  @override
  void dispose() {
    // broadcast streamをlistenしている場合は毎回subscriptionを閉じないといけない
    _subscription.cancel();
    super.dispose();
  }
}

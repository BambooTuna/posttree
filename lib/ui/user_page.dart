import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posttree/const/user_page.dart';
import 'package:posttree/model/user.dart';
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

  final bool _pinned = false;
  final bool _snap = false;
  final bool _floating = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          SliverAppBar(
            elevation: 0,
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            expandedHeight: 160.0,
            backgroundColor: Colors.transparent,
            flexibleSpace: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
              child: UserPageHeader(),
            ),
            leading: Builder(
              builder: (BuildContext context) {
                final ModalRoute<Object?>? parentRoute = ModalRoute.of(context);
                final bool canPop = parentRoute?.canPop ?? false;
                if (canPop) {
                  return BackButton();
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Text("プロフは実装中"),
            ),
          )
        ],
        body: SafeArea(
          child: UserPageBody(userId: this.userId),
        ),
      ),
      endDrawer: UserSettingWidget(),
    );
  }
}

class UserPageHeader extends StatefulWidget {
  @override
  _UserPageHeaderState createState() => _UserPageHeaderState();
}

class _UserPageHeaderState extends State<UserPageHeader> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      var userPageViewModel = watch(userPageViewModelProvider);
      var user = userPageViewModel.user ?? defaultUser();
      return FlexibleSpaceBar(
        stretchModes: <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
        ],
        title: UserIconWidget(
          iconSize: 100.0,
          radius: 45,
          onTap: () {},
          iconUrl:
              "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg",
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl:
                  "https://pbs.twimg.com/profile_images/1138564670325792769/lN3Ggmem_400x400.jpg",
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error, color: Theme.of(context).iconTheme.color),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
              child: Container(),
            )
          ],
        ),
      );
    });
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
      var userPostTableViewModel = watch(userPostTableViewModelProvider);
      var articleTableViewModel = watch(articleTableViewModelProvider);
      return TabBarWidget(tabs: [
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

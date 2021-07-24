import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posttree/const/user_page.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/view_model/user_page.dart';
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
    viewModel.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserPageViewModel>(
      builder: (context, viewModel, _) {

        if (viewModel.user == null) {
          return Container();
        } else {
          return Column(children: [
            UserIconWidget(
              iconSize: 240.0,
              radius: 120,
              onTap: () {},
              iconUrl: viewModel.user!.userIconImage.value,
            ),
            Expanded(child:
            TabBarWidget(
                tabs: [
                  Tab(
                    text: 'One',
                  ),
                  Tab(
                    text: 'Two',
                  )
                ],
                children: [
                  RefreshIndicator(
                      onRefresh: () async {
                        await viewModel.reload();
                      },
                      child: ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(5),
                        itemCount: viewModel.items.length,
                        itemBuilder: (BuildContext context, int i) {
                          final item = viewModel.items[i];
                          final userIcon = UserIconWidget(
                            iconSize: 48,
                            radius: 20,
                            onTap: () {
                              Navigator.of(context).pushNamed("/profile",
                                  arguments:
                                  UserPageArguments(item.user.userId.id));
                            },
                            iconUrl: item.user.userIconImage.value,
                          );
                          return Card(
                            color: Theme.of(context).cardTheme.color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: ListTile(
                                leading: item.isMine ? null : userIcon,
                                title: Row(children: <Widget>[
                                  Text(
                                    item.user.userName.value,
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                ]),
                                subtitle: Text(
                                  item.message,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                trailing: item.isMine ? userIcon : null,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 10);
                        },
                      )),

                  RefreshIndicator(
                      onRefresh: () async {
                        await viewModel.reload();
                      },
                      child: ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(5),
                        itemCount: viewModel.items.length,
                        itemBuilder: (BuildContext context, int i) {
                          final item = viewModel.items[i];
                          final userIcon = UserIconWidget(
                            iconSize: 48,
                            radius: 20,
                            onTap: () {
                              Navigator.of(context).pushNamed("/profile",
                                  arguments:
                                  UserPageArguments(item.user.userId.id));
                            },
                            iconUrl: item.user.userIconImage.value,
                          );
                          return Card(
                            color: Theme.of(context).cardTheme.color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: ListTile(
                                leading: item.isMine ? null : userIcon,
                                title: Row(children: <Widget>[
                                  Text(
                                    item.user.userName.value,
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                ]),
                                subtitle: Text(
                                  item.message,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                trailing: item.isMine ? userIcon : null,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 10);
                        },
                      ))
                ])
            )
          ]);

        }
      },
    );
  }
}

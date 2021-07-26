import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posttree/model/post_cart.dart';
import 'package:posttree/ui/post_form.dart';
import 'package:posttree/ui/user_page.dart';
import 'package:posttree/view_model/home.dart';
import 'package:posttree/view_model/post_form.dart';
import 'package:posttree/view_model/post_tables.dart';
import 'package:posttree/widget/post_card.dart';
import 'package:posttree/widget/refreshable_post_table.dart';
import 'package:posttree/widget/user_icon.dart';

import 'article.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Home",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: UserSmallIcon(),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: HomeBody(),
      floatingActionButton: _HomeFloatingActionButton(),
    );
  }
}

class UserSmallIcon extends StatefulWidget {
  @override
  _UserSmallIconState createState() => _UserSmallIconState();
}

class _UserSmallIconState extends State<UserSmallIcon> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      var viewModel = watch(homeViewModelProvider);
      if (viewModel.isLogin) {
        final iconUrl = viewModel.selfUser!.userIconImage.value;
        return UserIconWidget(
          iconSize: 48.0,
          radius: 20,
          onTap: () {
            Navigator.of(context).pushNamed("/profile",
                arguments: UserPageArguments(viewModel.selfUser!.userId.id));
          },
          iconUrl: iconUrl,
        );
      } else {
        return IconButton(
          padding: new EdgeInsets.all(0.0),
          icon: Icon(Icons.account_circle, size: 48.0),
          color: Theme.of(context).buttonColor,
          onPressed: () {
            Navigator.of(context).pushNamed("/login");
          },
        );
      }
    });
  }
}

class _HomeFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final viewModel = context.read(homeViewModelProvider);
        if (viewModel.isLogin) {
          openPostFormModal(context);
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("投稿はログインしてないと使えなさそう。。。"),
                );
              }).then((_) => Navigator.of(context).pushNamed("/login"));
        }
      },
      tooltip: 'Increment',
      child: Icon(Icons.edit),
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void initState() {
    super.initState();
    EasyLoading.dismiss();

    // Listen events by view model.
    var viewModel = context.read(homeViewModelProvider);
    viewModel.voidEventAction.stream.listen((user) {
      EasyLoading.dismiss();
    });
    viewModel.accountRepository.authState.forEach((element) {
      viewModel.refreshSelf();
    });
    viewModel.refreshTimeline();

    final postCart = context.read(postCartProvider);
    postCart.createArticleAction.stream.listen((article) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return ArticleScreen(article: article);
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final viewModel = watch(homeViewModelProvider);
      final postCart = watch(postCartProvider);
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                child: Text(postCart.editMode
                    ? "まとめるモード (${postCart.count})"
                    : "通常モード"),
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  shape: const StadiumBorder(),
                  side: BorderSide(
                      color:
                          postCart.editMode ? Colors.redAccent : Colors.green),
                ),
                onPressed: () {
                  if (!postCart.editMode) {
                    postCart.switchToEditMode();
                  } else {
                    postCart.summarize();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: RefreshableItemTable(
              items: viewModel.timelineItems.map((e) {
                final card = PostCard(item: e);
                if (postCart.editMode) {
                  final exist = postCart.exist(e);
                  return Opacity(
                    opacity: exist ? 0.5 : 1.0,
                    child: Dismissible(
                        key: Key(e.id),
                        direction: exist
                            ? DismissDirection.endToStart
                            : DismissDirection.startToEnd,
                        onDismissed: (direction) {},
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            postCart.del(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('削除しました')));
                          } else {
                            postCart.add(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('追加しました')));
                          }
                          return false;
                        },
                        background: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.greenAccent[200],
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                              child: Icon(Icons.add, color: Colors.white)),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.centerRight,
                          color: Colors.redAccent[200],
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 20.0, 0.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                        child: card),
                  );
                } else {
                  return card;
                }
              }).toList(),
              onRefresh: () {
                return viewModel.refreshTimeline();
              },
              lastWidget: Center(
                  child: Text(
                "みんなの投稿が表示されるよ、下に引っ張ってリロード",
                style: Theme.of(context).textTheme.bodyText1,
              )),
            ),
          ),
        ],
      );
    });
  }
}

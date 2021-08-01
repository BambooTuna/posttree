import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posttree/model/post_cart.dart';
import 'package:posttree/ui/post_form.dart';
import 'package:posttree/ui/user_page.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/view_model/authentication.dart';
import 'package:posttree/view_model/home.dart';
import 'package:posttree/widget/post_card.dart';
import 'package:posttree/widget/refreshable_post_table.dart';
import 'package:posttree/widget/user_icon.dart';

import 'article.dart';

class Home extends StatelessWidget {
  final bool _pinned = false;
  final bool _snap = false;
  final bool _floating = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          SliverAppBar(
            elevation: 0,
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "posttree",
                style: Theme.of(context).textTheme.headline6,
              ),
              // background: FlutterLogo(),
            ),
            leading: UserSmallIcon(),
            actions: [ArticleCartButton()],
          ),
        ],
        body: SafeArea(
          child: HomeBody(),
        ),
      ),
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
      final authenticationViewModel = watch(authenticationViewModelProvider);
      if (authenticationViewModel.isLogin) {
        final iconUrl = authenticationViewModel.selfUser!.userIconImage;
        return Padding(
          padding: EdgeInsets.all(5),
          child: UserIconWidget(
            iconSize: 48.0,
            radius: 20,
            onTap: () {
              Navigator.of(context).pushNamed("/profile",
                  arguments: UserPageArguments(
                      authenticationViewModel.selfUser!.userId));
            },
            iconUrl: iconUrl,
          ),
        );
      } else {
        return IconButton(
          padding: EdgeInsets.all(5),
          icon: Icon(
            Icons.account_circle,
            size: 48.0,
            color: Theme.of(context).iconTheme.color,
          ),
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
    return Consumer(builder: (context, watch, child) {
      return FloatingActionButton(
        onPressed: () {
          final authenticationViewModel =
              watch(authenticationViewModelProvider);
          if (authenticationViewModel.isLogin) {
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
    });
  }
}

class ArticleCartButton extends StatefulWidget {
  @override
  _ArticleCartButtonState createState() => _ArticleCartButtonState();
}

class _ArticleCartButtonState extends State<ArticleCartButton> {
  _onPressSummarize(
      PostCart postCart, AuthenticationViewModel authenticationViewModel) {
    if (!postCart.editMode) {
      postCart.switchToEditMode();
    } else {
      if (postCart.count == 0) {
        postCart.summarize(authenticationViewModel.selfUser, "");
        return;
      }
      showDialog(
          context: context,
          builder: (context) {
            final _formKey = GlobalKey<FormBuilderState>();
            return AlertDialog(
              title: Text('タイトル'),
              content: SizedBox(
                height: 100,
                child: FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(children: <Widget>[
                    FormBuilderTextField(
                      name: "title",
                      autofocus: true,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.maxLength(context, 30),
                      ]),
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ]),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('キャンセル'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('作成'),
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      Navigator.pop(context);
                      postCart.summarize(authenticationViewModel.selfUser,
                          _formKey.currentState!.value['title']);
                    }
                    //OKを押したあとの処理
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final authenticationViewModel = watch(authenticationViewModelProvider);
      final postCart = watch(postCartProvider);
      return Padding(
        padding: EdgeInsets.all(5),
        child: postCart.editMode
            ? IconButton(
                icon: Stack(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 28.0,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.redAccent[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          "${postCart.count}",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
                onPressed: () {
                  _onPressSummarize(postCart, authenticationViewModel);
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.bookmarks,
                  size: 28.0,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  postCart.switchToEditMode();
                },
              ),
      );
    });
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late StreamSubscription<Event> _subscription;

  @override
  void initState() {
    super.initState();
    EasyLoading.dismiss();

    // Listen events by view model.
    var authenticationViewModel = context.read(authenticationViewModelProvider);
    _subscription = authenticationViewModel.listen();

    var viewModel = context.read(homeViewModelProvider);
    viewModel.voidEventAction.stream.listen((user) {
      EasyLoading.dismiss();
    });
    viewModel.refreshTimeline(authenticationViewModel.selfUser);

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
      final authenticationViewModel = watch(authenticationViewModelProvider);
      final PostCart postCart = watch(postCartProvider);
      return Column(
        children: [
          // TODO
          Center(
            child: postCart.editMode
                ? Text("まとめるモードでは投稿をスワイプしてリストに追加できる\n"
                    "リストに投稿が入っている状態でもう一度押すと作成できるよ")
                : Text("右上のボランを押してまとめるモードに移行できるよ"),
          ),
          SizedBox(height: 12),
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
                return viewModel
                    .refreshTimeline(authenticationViewModel.selfUser);
              },
              lastWidget: Center(
                  child: Text(
                "みんなの投稿が表示されるよ、下に引っ張ってリロード",
                style: Theme.of(context).textTheme.bodyText1,
              )),
            ),
          )
        ],
      );
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posttree/main.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/model/post_cart.dart';
import 'package:posttree/ui/post_form.dart';
import 'package:posttree/ui/user_page.dart';
import 'package:posttree/view_model/home.dart';
import 'package:posttree/view_model/post_form.dart';
import 'package:posttree/view_model/post_tables.dart';
import 'package:posttree/widget/post_card.dart';
import 'package:posttree/widget/refreshable_post_table.dart';
import 'package:posttree/widget/user_icon.dart';

final homeViewModelProvider = ChangeNotifierProvider(
  (ref) => HomeViewModel(),
);
final postCartProvider = ChangeNotifierProvider(
  (ref) => PostCart(),
);
final timelinePostTableViewModelProvider = ChangeNotifierProvider(
  (ref) => TimelinePostTableViewModel(),
);
final postFormViewModelProvider = ChangeNotifierProvider(
  (ref) => PostFormViewModel(),
);

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
        final iconUrl = viewModel.user.userIconImage.value;
        return UserIconWidget(
          iconSize: 48.0,
          radius: 20,
          onTap: () {
            Navigator.of(context).pushNamed("/profile",
                arguments: UserPageArguments(viewModel.user.userId.id));
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
        final postFormViewModel = context.read(postFormViewModelProvider);
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

    // Listen events by view model.
    var viewModel = context.read(homeViewModelProvider);
    var authenticateViewModel = context.read(authenticateViewModelProvider);
    authenticateViewModel.authenticateSuccessAction.stream.listen((user) {
      viewModel.setUser(user);
    });
    // authenticateViewModel.signOut();
    authenticateViewModel.authenticate();

    var timelinePostTableViewModel =
        context.read(timelinePostTableViewModelProvider);
    timelinePostTableViewModel.load(viewModel.user.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      var viewModel = context.read(homeViewModelProvider);
      var postCart = watch(postCartProvider);
      var timelinePostTableViewModel =
          watch(timelinePostTableViewModelProvider);
      return Column(
        children: [
          DragTarget<Post>(
            // ドラッグ先の領域
            builder: (context, accepted, rejected) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      // color: _willAccepted ? Colors.orange : Colors.transparent,
                      // width: _willAccepted ? 1 : 1,
                      ),
                ),
                height: 300,
                child: Center(
                  child: Image.network(
                      'https://4.bp.blogspot.com/-6Sr0RZ5rlAQ/UYh8w3M6Z_I/AAAAAAAARRY/_c7ewyEIZYY/s400/shinkai_ryugunotsukai.png'),
                ),
              );
            },
            // ③
            onWillAccept: (data) {
              return true;
            },
            onAccept: (data) {
              postCart.add(data);
            },
            onLeave: (data) {},
          ),
          Expanded(
            child: RefreshableItemTable(
              items: timelinePostTableViewModel.items.map((e) {
                final card = PostCard(item: e);
                if (postCart.exist(e)) {
                  return Opacity(
                    opacity: 0.5,
                    child: card,
                  );
                } else {
                  if (postCart.editMode) {
                    return Draggable(
                        data: e,
                        child: card,
                        feedback: Icon(
                          Icons.satellite,
                          size: 128,
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.5, // 完全に透明にする
                          child: card,
                        ));
                  } else {
                    return card;
                  }
                }
              }).toList(),
              onRefresh: () {
                return timelinePostTableViewModel.load(viewModel.user.userId);
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

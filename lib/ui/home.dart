import 'package:flutter/material.dart';
import 'package:posttree/ui/user_page.dart';
import 'package:posttree/view_model/authenticate.dart';
import 'package:posttree/view_model/home.dart';
import 'package:posttree/view_model/post_tables.dart';
import 'package:posttree/widget/post_card.dart';
import 'package:posttree/widget/refreshable_post_table.dart';
import 'package:posttree/widget/user_icon.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => TimelinePostTableViewModel()),
      ],
      child: Scaffold(
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
      ),
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
    var viewModel = Provider.of<HomeViewModel>(context);
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
      return UserIconWidget(
        iconSize: 48.0,
        radius: 20,
        onTap: () {
          Navigator.of(context).pushNamed("/login");
        },
        iconUrl:
            "https://cdn.pixabay.com/photo/2013/07/12/19/24/anonymous-154716_1280.png",
      );
    }
  }
}

class _HomeFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final viewModel = Provider.of<HomeViewModel>(context, listen: false);
        showModalBottomSheet<void>(
          context: context,
          // isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          builder: (BuildContext context) {
            return Container(
              height: 400,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Modal BottomSheet'),
                    ElevatedButton(
                      child: const Text('Close BottomSheet'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
            );
          },
        );
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
    var viewModel = Provider.of<HomeViewModel>(context, listen: false);
    var authenticateViewModel =
        Provider.of<AuthenticateViewModel>(context, listen: false);
    authenticateViewModel.authenticateSuccessAction.stream.listen((user) {
      viewModel.setUser(user);
    });
    // authenticateViewModel.signOut();
    authenticateViewModel.authenticate();

    var timelinePostTableViewModel =
        Provider.of<TimelinePostTableViewModel>(context, listen: false);
    timelinePostTableViewModel.reload();
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<TimelinePostTableViewModel>(context);
    return Column(
      children: [
        Expanded(
          child: RefreshableItemTable(
            items: viewModel.items.map((e) => PostCard(item: e)).toList(),
            onRefresh: viewModel.reload,
            lastWidget: Center(
                child: Text(
              "みんなの投稿が表示されるよ、下に引っ張ってリロード",
              style: Theme.of(context).textTheme.bodyText1,
            )),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:posttree/ui/user_page.dart';
import 'package:posttree/view_model/authenticate.dart';
import 'package:posttree/view_model/home.dart';
import 'package:posttree/widget/user_icon.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Home",
            style: Theme.of(context).primaryTextTheme.headline4,
          ),
          leading: UserSmallIcon(),
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
      final icon = viewModel.user.userIconImage == null
          ? Icon(IconData(0xee41, fontFamily: 'MaterialIcons'))
          : Image.network(
              viewModel.user.userIconImage!.value,
              fit: BoxFit.cover,
            );
      return UserIcon(
        iconSize: 48.0,
        onTap: () {
          Navigator.of(context).pushNamed("/profile",
              arguments: UserPageArguments(viewModel.user.userId.id));
        },
        child: icon,
      );
    } else {
      return UserIcon(
        iconSize: 48.0,
        onTap: () {
          Navigator.of(context).pushNamed("/login");
        },
        child: Icon(IconData(0xee41, fontFamily: 'MaterialIcons')),
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
        if (viewModel.isLogin) {
          viewModel.incrementCounter();
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("カウンターを使いたいならログインしてちょ"),
                );
              }).then((_) => Navigator.of(context).pushNamed("/login"));
        }
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
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
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            Provider.of<HomeViewModel>(context).counter.toString(),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            Provider.of<HomeViewModel>(context).user.userName.value,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}

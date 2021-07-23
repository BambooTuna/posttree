import 'package:flutter/material.dart';
import 'package:posttree/style/colors.dart';
import 'package:posttree/view_model/authenticate.dart';
import 'package:posttree/view_model/home.dart';
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
  static const iconSize = 48.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<HomeViewModel>(context);
    final userIconImage = viewModel.user.userIconImage;
    final icon = userIconImage == null
        ? Icon(IconData(0xee41, fontFamily: 'MaterialIcons'))
        : Image.network(
            userIconImage.value,
            fit: BoxFit.cover,
          );

    return Container(
      width: iconSize,
      height: iconSize,
      margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).cardColor, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
            onTap: () {
              if (viewModel.isLogin) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Unimplemented: ユーザーページに飛ぶ"),
                      );
                    });
              } else {
                Navigator.of(context).pushNamed("/login");
              }
            },
            child: icon),
      ),
    );
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
    authenticateViewModel.signOut();
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

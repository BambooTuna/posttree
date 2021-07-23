import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:posttree/const/user_page.dart';
import 'package:posttree/model/user.dart';
import 'package:posttree/utils/event.dart';
import 'package:posttree/view_model/user_page.dart';
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
        ),

        // extendBodyBehindAppBar: true,
        body: UserPageBody(),
        endDrawer: UserSettingDrawer(),
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
    viewModel.getUserProfile();
  }

  static const locations = [1, 2, 3, 4, 5];
  @override
  Widget build(BuildContext context) {
    return Consumer<UserPageViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.user == null) {
          return Container();
        } else {
          final icon = viewModel.user!.userIconImage == null
              ? Icon(Icons.supervisor_account)
              : CachedNetworkImage(
                  imageUrl: viewModel.user!.userIconImage!.value,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );

          SingleChildScrollView(
              child: ListView(children: <Widget>[
            UserIcon(
              iconSize: 240.0,
              radius: 120,
              onTap: () {},
              child: icon,
            ),
            for (final location in locations)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [],
                    ),
                  ),
                ),
              ),
          ]));

          return SingleChildScrollView(
              child: Column(children: <Widget>[
            UserIcon(
              iconSize: 240.0,
              radius: 120,
              onTap: () {},
              child: icon,
            ),
            for (final location in locations)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [],
                    ),
                  ),
                ),
              ),
          ]));
        }
      },
    );
  }
}

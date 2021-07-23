import 'package:flutter/material.dart';
import 'package:posttree/ui/user_page.dart';
import 'package:posttree/view_model/post_tables.dart';
import 'package:posttree/widget/user_icon.dart';
import 'package:provider/provider.dart';

class PostTable extends StatefulWidget {
  @override
  _PostTableState createState() => _PostTableState();
}

class _PostTableState extends State<PostTable> {
  @override
  void initState() {
    super.initState();

    var viewModel = Provider.of<PostTableViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostTableViewModel>(
      builder: (context, viewModel, _) {
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
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
            ),
          ],
        );
      },
    );
  }
}

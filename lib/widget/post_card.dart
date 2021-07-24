import 'package:flutter/material.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/ui/user_page.dart';
import 'package:posttree/widget/user_icon.dart';

class PostCard extends StatelessWidget {
  final Post item;
  PostCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final userIcon = UserIconWidget(
      iconSize: 48,
      radius: 20,
      onTap: () {
        Navigator.of(context).pushNamed("/profile",
            arguments: UserPageArguments(item.user.userId.id));
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
  }
}

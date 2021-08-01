import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:posttree/model/article.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/ui/article.dart';
import 'package:posttree/ui/user_page.dart';
import 'package:posttree/widget/user_icon.dart';

class ArticleCard extends StatelessWidget {
  final Article item;
  ArticleCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final userIcon = UserIconWidget(
      iconSize: 48,
      radius: 20,
      onTap: () {
        Navigator.of(context).pushNamed("/profile",
            arguments: UserPageArguments(item.author.userId));
      },
      iconUrl: item.author.userIconImage,
    );

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ArticleScreen(article: item);
            }));
          },
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  userIcon,
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              item.title,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                ]),
          ),
        ),
      ),
    );
  }
}

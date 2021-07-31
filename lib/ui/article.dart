import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:posttree/model/article.dart';
import 'package:posttree/widget/post_card.dart';
import 'package:posttree/widget/refreshable_post_table.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;
  ArticleScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Article",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: StaticItemTable(
        items: article.posts.map((e) => PostCard(item: e)).toList(),
        lastWidget: Center(
            child: Text(
          "まとめたものはここに表示されるよ、自分だけのposttreeを作ろう",
          style: Theme.of(context).textTheme.bodyText1,
        )),
      ),
    );
  }
}

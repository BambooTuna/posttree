import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/ui/user_page.dart';
import 'package:posttree/widget/user_icon.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

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
            arguments: UserPageArguments(item.user.userId));
      },
      iconUrl: item.user.userIconImage,
    );

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                userIcon,
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            item.user.userName,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                      ParsedText(
                        text: item.message,
                        style: Theme.of(context).textTheme.bodyText1,
                        parse: <MatchText>[
                          MatchText(
                            pattern: urlPattern,
                            type: ParsedType.URL,
                            renderWidget: (
                                {required String pattern,
                                required String text}) {
                              return SimpleUrlPreview(
                                url: text,
                                bgColor: Colors.white,
                                titleLines: 1,
                                descriptionLines: 2,
                                imageLoaderColor: Colors.white,
                                titleStyle:
                                    Theme.of(context).textTheme.headline6,
                                descriptionStyle:
                                    Theme.of(context).textTheme.bodyText1,
                                siteNameStyle:
                                    Theme.of(context).textTheme.caption,
                              );
                            },
                            onTap: (url) {
                              print(url);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                )),
              ]),
        ),
      ),
    );
  }
}

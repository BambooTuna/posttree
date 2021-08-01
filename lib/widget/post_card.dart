import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:posttree/model/post.dart';
import 'package:posttree/ui/user_page.dart';
import 'package:posttree/widget/user_icon.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

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
                              if (UniversalPlatform.isWeb) {
                                return InkWell(
                                  hoverColor: Colors.transparent,
                                  child: Text(
                                    text,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(color: Colors.blue),
                                  ),
                                  onTap: () {
                                    launch(text, forceWebView: true);
                                  },
                                );
                              }
                              return FlutterLinkPreview(
                                  url: text,
                                  titleStyle:
                                      Theme.of(context).textTheme.headline6,
                                  bodyStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  builder: (info) {
                                    switch (info.runtimeType) {
                                      case WebInfo:
                                        return AnyLinkPreview(
                                          link: text,
                                          displayDirection:
                                              UIDirection.UIDirectionVertical,
                                          showMultimedia: true,
                                          bodyMaxLines: 3,
                                          bodyTextOverflow:
                                              TextOverflow.ellipsis,
                                          titleStyle: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                          bodyStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          errorBody: 'cannot preview this link',
                                          errorTitle: 'error',
                                          errorWidget: InkWell(
                                            hoverColor: Colors.transparent,
                                            child: Text(
                                              text,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.copyWith(
                                                      color: Colors.blue),
                                            ),
                                            onTap: () {
                                              launch(text, forceWebView: true);
                                            },
                                          ),
                                          errorImage: "https://google.com/",
                                          cache: Duration(days: 7),
                                        );
                                      case WebImageInfo:
                                        return SizedBox(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            clipBehavior: Clip.antiAlias,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  (info as WebImageInfo).image,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        );
                                      case WebVideoInfo:
                                        return InkWell(
                                          hoverColor: Colors.transparent,
                                          child: Text(
                                            text,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.copyWith(color: Colors.blue),
                                          ),
                                          onTap: () {
                                            launch(text, forceWebView: true);
                                          },
                                        );
                                      default:
                                        return const SizedBox();
                                    }
                                  });

                              // return SimpleUrlPreview(
                              //   url: text,
                              //   bgColor: Colors.white,
                              //   titleLines: 1,
                              //   descriptionLines: 2,
                              //   imageLoaderColor: Colors.white,
                              //   titleStyle:
                              //       Theme.of(context).textTheme.headline6,
                              //   descriptionStyle:
                              //       Theme.of(context).textTheme.bodyText1,
                              //   siteNameStyle:
                              //       Theme.of(context).textTheme.caption,
                              // );
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

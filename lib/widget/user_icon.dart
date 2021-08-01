import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserIconWidget extends StatelessWidget {
  final double iconSize;
  final double radius;
  final Function()? onTap;
  final String iconUrl;
  UserIconWidget(
      {required this.iconSize,
      required this.radius,
      this.onTap,
      required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Container(
          width: this.iconSize,
          height: this.iconSize,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: Theme.of(context).cardColor, width: 1.5),
            borderRadius: BorderRadius.circular(this.radius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(this.radius),
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: this.iconUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error, color: Theme.of(context).iconTheme.color),
            ),
          ),
        ),
      ),
    );
  }
}

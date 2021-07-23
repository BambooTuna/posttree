import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  final double iconSize;
  final Function()? onTap;
  final Widget? child;
  UserIcon({required this.iconSize, this.onTap, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.iconSize,
      height: this.iconSize,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).cardColor, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(this.iconSize / 2),
        child: InkWell(onTap: onTap, child: this.child),
      ),
    );
  }
}

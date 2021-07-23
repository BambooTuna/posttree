import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  final double iconSize;
  final double radius;
  final Function()? onTap;
  final Widget? child;
  UserIcon(
      {required this.iconSize, required this.radius, this.onTap, this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
          child: this.child,
        ),
      ),
    );
  }
}

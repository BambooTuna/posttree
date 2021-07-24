import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshableItemTable extends StatelessWidget {
  final List<Widget> items;
  final Future<void> Function() onRefresh;
  RefreshableItemTable({required this.items, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: this.onRefresh,
        child: ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(5),
          itemCount: this.items.length,
          itemBuilder: (BuildContext context, int i) {
            return this.items[i];
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 10);
          },
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshableItemTable extends StatelessWidget {
  final List<Widget> items;
  final Future<void> Function() onRefresh;
  final Widget? lastWidget;
  RefreshableItemTable(
      {required this.items, required this.onRefresh, this.lastWidget});

  @override
  Widget build(BuildContext context) {
    final _items = this.lastWidget == null
        ? this.items
        : [...this.items, this.lastWidget!];
    return RefreshIndicator(
        onRefresh: this.onRefresh,
        child: ListView.separated(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(5),
          itemCount: _items.length,
          itemBuilder: (BuildContext context, int i) {
            return _items[i];
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 10);
          },
        ));
  }
}

class StaticItemTable extends StatelessWidget {
  final List<Widget> items;
  final Widget? lastWidget;
  StaticItemTable({required this.items, this.lastWidget});

  @override
  Widget build(BuildContext context) {
    final _items = this.lastWidget == null
        ? this.items
        : [...this.items, this.lastWidget!];
    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(5),
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int i) {
        return _items[i];
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 10);
      },
    );
  }
}

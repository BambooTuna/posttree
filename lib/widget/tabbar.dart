import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  final List<Tab> tabs;
  final List<Widget> children;
  TabBarWidget({required this.tabs, required this.children});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: this.tabs.length,
      child: Column(children: [
        TabBar(
          tabs: this.tabs,
          unselectedLabelColor:
              Theme.of(context).tabBarTheme.unselectedLabelColor,
          indicatorColor: Theme.of(context).indicatorColor,
          indicatorSize: Theme.of(context).tabBarTheme.indicatorSize,
          indicatorWeight: 2,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          indicator: Theme.of(context).tabBarTheme.indicator,
          labelColor: Theme.of(context).tabBarTheme.labelColor,
        ),
        Expanded(child: TabBarView(children: this.children))
      ]),
    );
  }
}

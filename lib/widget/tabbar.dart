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
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 2,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          // indicator: CustomTabIndicator(),
          labelColor: Colors.black,
        ),
        Expanded(child: TabBarView(children: this.children))
      ]),
    );
  }
}

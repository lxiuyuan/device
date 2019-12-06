import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'controller.dart';
import 'delegate.dart';
export 'controller.dart';

class TabWidget extends StatefulWidget {
  final Widget lineWidget;
  final TabWidgetController controller;
  final Widget Function(BuildContext,int index,bool isSelect) builder;
  final int length;
  TabWidget(
      {@required this.builder, @required this.controller,this.length=5, this.lineWidget});

  @override
  _TabWidgetState createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget>
    with SingleTickerProviderStateMixin {
  TabWidgetController c;

  @override
  void initState() {
    c = widget.controller;
    c.registerState(this);
    c.registerAnimation(AnimationController(vsync: this));
    super.initState();
  }

  List<Widget> getTabs() {
    List<Widget> tabs = [];
    for (int i = 0; i < widget.length; i++) {
      tabs.add(LayoutId(
          id: "tab$i",
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () {
                  c.onItemClick(i);
                },
                child: widget.builder(context,i,i==c.page)),
          )));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(splashColor: Colors.transparent),
      child: CustomMultiChildLayout(
        delegate: TabDelegate(length: widget.length, position: c.position),
        children: <Widget>[]
          ..addAll(getTabs())
          ..add(LayoutId(
            id: "line",
            child: widget.lineWidget,
          )),
      ),
    );
  }
}

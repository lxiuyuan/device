import 'package:flutter/material.dart';
import 'child.dart';
import 'controller.dart';
export 'child.dart';

class CompositeSliverScroll extends StatefulWidget {
  List<Composite> children;
  CompositeSliverScroll({this.children});

  @override
  _CompositeScrollViewState createState() => _CompositeScrollViewState();
}

class _CompositeScrollViewState extends State<CompositeSliverScroll> {
  CompositeController _c = CompositeController();

  @override
  void initState() {
    super.initState();
    _c.widget = widget;
  }

  @override
  void didUpdateWidget(CompositeSliverScroll oldWidget) {
    _c.widget = widget;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(delegate: SliverChildBuilderDelegate(
       (ctx, index) {
        return _c.itemBuild(ctx, index);
      },
      childCount:_c.length ,
    ));
  }
}

class KeepAliveSWidget extends StatefulWidget {
  final Widget child;

  KeepAliveSWidget({Key key, this.child}) : super(key: key);

  @override
  _KeepAliveSWidgetState createState() => _KeepAliveSWidgetState();
}

class _KeepAliveSWidgetState extends State<KeepAliveSWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

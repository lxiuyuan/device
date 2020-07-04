import 'package:flutter/material.dart';
import 'view.dart';

abstract class Composite {
  int lineCount();

  Widget getWidget(BuildContext context, int position);
}

class CompositeGrid extends Composite {
  final double mainSpacing;
  final double crossSpacing;
  final IndexedWidgetBuilder builder;
  final int length;
  final int crossAxisCount;
  final EdgeInsets padding;

  GlobalObjectKey __key=GlobalObjectKey("CompositeGrid");
  CompositeGrid(this.builder,
      {this.length = 10000,
        this.padding,
      this.crossAxisCount = 1,
      this.mainSpacing=0.0,
      this.crossSpacing=0.0});


  @override
  String toString() {
    return "CompositeGrid(length:${length},crossAxisCount:${crossAxisCount})";
  }

  @override
  int lineCount() {
    return length % crossAxisCount == 0
        ? (length ~/ crossAxisCount).toInt()
        : (length ~/ crossAxisCount).toInt() + 1;
  }



  Widget _getChild(BuildContext context, int position) {
    if (position >= length) {
      return Expanded(child: Container());
    }
    return Expanded(child: builder(context, position));
  }



  List<Widget> getChildren(BuildContext context, int position) {
    List<Widget> children = [];
    var gridPosition = position * crossAxisCount;
    var left=padding?.left??0.0;
    var right=padding?.right??0.0;
    for (int i = 0; i < crossAxisCount; i++) {
      //添加间隔
      if(i!=0){
        children.add(SizedBox(width: mainSpacing,));
      }else{
        children.add(SizedBox(width: left,));
      }
      children.add(_getChild(context, gridPosition + i));
      //添加距离
      if(i==crossAxisCount-1){
        children.add(SizedBox(width: right,));
      }

    }
    return children;
  }

  @override
  Widget getWidget(BuildContext context, int position) {
    var marginTop=padding?.top??0.0;
    var marginBottom=padding?.bottom??0.0;
    double top=(position == 0 ?marginTop : crossSpacing);
    double bottom=(position == lineCount()-1 ?marginBottom : 0.0);

    return KeepAliveSWidget(
      child: Column(
        children: <Widget>[
          SizedBox(height: top,),
          Row(
            children: getChildren(context, position),
          ),
          SizedBox(height: bottom,),
        ],
      ),
    );
  }
}

class CompositeList extends Composite {
  final IndexedWidgetBuilder builder;
  final int length;

  CompositeList(this.builder, {this.length = 10000});

  @override
  int lineCount() {
    return length;
  }

  @override
  Widget getWidget(BuildContext context, int position) {
    return KeepAliveSWidget(child: builder(context, position));
  }
}

class CompositeColumn extends Composite{
  final List<Widget> children;
  CompositeColumn({@required this.children});
  GlobalObjectKey __key=GlobalObjectKey("CompositeColumn");
  @override
  Widget getWidget(BuildContext context, int position) {
    return KeepAliveSWidget(key:__key,child: children[position]);
  }
  @override
  String toString() {
    return "CompositeColumn(length:${children.length})";
  }
  @override
  int lineCount() {
    return children.length;
  }

}

class CompositeGroup extends Composite {
  final Widget child;

  CompositeGroup({this.child});

  @override
  int lineCount() {
    return 1;
  }

  @override
  Widget getWidget(BuildContext context, int position) {
    return KeepAliveSWidget(child: child);
  }
}

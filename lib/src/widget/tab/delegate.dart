

import 'package:flutter/material.dart';

class TabDelegate extends MultiChildLayoutDelegate{

  final int length;
  final double position;
  TabDelegate({this.length,this.position});

  List<Offset> initPosition(double width,double height){
    List<Offset> offsets=[];
    double x=0;

    for(int i=0;i<length;i++) {
      offsets.add(Offset(x, 0));
      x+=width;
    }
    return offsets;
  }


  @override
  void performLayout(Size size) {
    var width=size.width/length;
    var height=size.height;
    var rects=initPosition(width,height);

    for(int i=0;i<length;i++) {

      layoutChild("tab$i", BoxConstraints.expand(width: width,height: height));
      positionChild("tab$i", rects[i]);
    }
    var s=layoutChild("line", BoxConstraints.loose(size));
    var left=(width-s.width)/2;
    positionChild("line",Offset(calcLineLeft(rects,left,width), size.height-3));
  }

  double calcLineLeft(List<Offset> rects,double left,double width){
    var p=position.toInt();
    var plan=position-p;
    var l=left+rects[p].dx+width*plan;
    return l;
  }

  @override
  bool shouldRelayout(TabDelegate oldDelegate) {
    return oldDelegate.length!=length||
        oldDelegate.position!=position;
  }

}
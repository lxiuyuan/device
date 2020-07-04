import 'package:flutter/src/widgets/framework.dart';
import 'view.dart';

class CompositeController{
  CompositeSliverScroll widget;

  int get length{
    var i=0;
    for(var child in widget.children){
      i+=child.lineCount();
    }
    print("children-count:${i}");
    return i;
  }
  ///根据index查找Composite
  CompositePosition findCompositePositionByIndex(int index){
    var count=0;
    for(var child in widget.children){
      var c=child.lineCount();
      count+=c;
      if(index<count){
        ///计算实际position
        var position=c+index-count;
        return CompositePosition(position,child);
      }
    }
    return null;
  }

  Widget itemBuild(BuildContext ctx, int index) {
    var result=findCompositePositionByIndex(index);
    var widget=result.composite.getWidget(ctx,result.position);
    return widget;
  }
}

class CompositePosition{
  final int position;
  final Composite composite;
  CompositePosition(this.position,this.composite);
}
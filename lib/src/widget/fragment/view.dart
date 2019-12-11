
import 'package:drive/drive.dart';
import 'package:flutter/material.dart';

import 'controller.dart';
export 'controller.dart';

class FragmentWidget extends StatefulWidget {
  final List<BaseController> children;
  final FragmentController controller;

  FragmentWidget({@required this.controller,  this.children});

  @override
  _FragmentWidgetState createState() => _FragmentWidgetState();
}

class _FragmentWidgetState extends State<FragmentWidget> {
  FragmentController controller;

  @override
  void initState() {
    this.controller = widget.controller;
    controller.registerState(this);

    controller.firstResume();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IndexedStack(
        key: controller.stackKey,
        index: controller.index,
        children: widget.children.map((BaseController controller){
          return controller.page.widget;
        }).toList(),
      ),
    );

  }
}

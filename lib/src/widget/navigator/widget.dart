import 'package:flutter/material.dart';

import 'controller.dart';

class ActionWidget extends StatefulWidget {
  final VoidCallback onDismissListener;
  final PopAction action;
  final WsyTransitionBuilder transition;
  final bool isDismiss;

  ActionWidget(
      {@required  this.action,
      this.onDismissListener,this.transition,this.isDismiss }):super(key:action.key) ;

  @override
  _ActionWidgetState createState() => _ActionWidgetState();
}

class _ActionWidgetState extends State<ActionWidget>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> _animation;
  var isDismissing = false;

  _ActionWidgetState();

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(animationController);
    _initListener();
    animationController.reset();
    animationController.forward(from: 0);
  }

  void _initListener() {
    animationController.addStatusListener((state) {
      if(!widget.action.isDismiss||!isDismissing){
        return;
      }

    });
  }

  @override
  void didUpdateWidget(ActionWidget oldWidget) {
    if (widget.isDismiss) {
      dismiss();
    }
    super.didUpdateWidget(oldWidget);
  }

  void dismiss() {
    if (isDismissing) {
      if(animationController.status==AnimationStatus.forward||animationController.status==AnimationStatus.completed){
        isDismissing=false;
      }else {
        return;
      }
    }

    if(animationController.status==AnimationStatus.dismissed){
      Future.delayed(Duration(milliseconds: 50),(){
        dismiss();
        return;
      });
    }
    isDismissing = true;
    animationController.reverse(from: 1);
    Future.delayed(Duration(milliseconds: 410),(){
      isDismissing = false;
      widget.onDismissListener();
    });
    setState(() {});
  }

  @override
  void dispose() {
//    widget.state = null;
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FadeTransition(
          opacity: _animation,
          child: GestureDetector(
            onTap: () {
              widget.action.isDismiss=true;
              dismiss();
            },
            child: Container(
              color: widget.action.barrierDismissible
                  ? Colors.transparent
                  : Color(0x99000000),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints.expand(),
          alignment: widget.action.alignment,
          child: widget.transition(context, _animation, widget.action.child),
        ),
      ],
    );
  }
}

class DismissCall {
  VoidCallback callBack;
}

typedef WsyTransitionBuilder = Widget Function(
    BuildContext context, Animation<double> animation, Widget child);

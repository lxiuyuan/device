import 'package:flutter/material.dart';
import 'widget.dart';
import 'controller.dart';
export 'controller.dart';

class DialogNavigator extends StatefulWidget {
  final DialogNavigatorController controller;

  DialogNavigator({this.controller});

  @override
  DialogNavigatorState createState() => DialogNavigatorState();

  static DialogNavigatorState of(BuildContext context) {
    return DialogNavigatorState();
  }
}

class DialogNavigatorState extends State<DialogNavigator> {
  DialogNavigatorController _c;
  DialogNavigatorController get controller=>_c;

  bool popLast(){
    return _c.backPressed();
  }

  final Animatable<double> _dialogScaleTween =
      Tween<double>(begin: 1.3, end: 1.0);

  @override
  void initState() {
    _c = widget.controller ?? DialogNavigatorController();
    _c.state = this;
    _c.refreshCallBack = () {
      try {
        if(this.context==null)
          return;
        if (this.mounted) setState(() {});
      }catch(e){
        Future.delayed(Duration(milliseconds: 50),(){
          _c.refreshCallBack();
        });
        print(e.toString());
      }
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: _c.widgets.length > 0,
        child: Container(
          child: Stack(
            children: _c.widgets.reversed.map((item) {
              return ActionWidget(
                action: item,
                isDismiss: item.isDismiss,
                onDismissListener: () {
                  if (item.isDismiss) _c.onDismissListener(item);
                },
                transition: item.transition ??
                    (ctx, anim, child) {
                      if (anim.status == AnimationStatus.reverse) {
                        return FadeTransition(
                          opacity: anim,
                          child: child,
                        );
                      }
                      final CurvedAnimation fadeAnimation = CurvedAnimation(
                        parent: anim,
                        curve: Curves.fastOutSlowIn,
                      );
                      Animation<double> sanim =
                          fadeAnimation.drive(_dialogScaleTween);
                      return FadeTransition(
                        opacity: anim,
                        child: ScaleTransition(scale: sanim, child: child),
                      );
                    },
              );
            }).toList(),
          ),
        ));
  }
}

import 'package:drive/src/widget/material_app.dart';
import 'package:flutter/material.dart';

class DialogUtils {
//展示中间的dialog
  static void showCenterDialog(Widget widget,
      {String type = "center",
      bool barrierDismissible = true,
      String tag = "",
      VoidCallback onDismissListener}) {
    WsyMaterialApp.navigatorController.show(widget, type,
        tag: tag,
        barrierDismissible: barrierDismissible,
        onDismissListener: onDismissListener,
        transition: _buildCupertinoDialogTransitions);
  }

  //展示right弹窗
  static void showRightDialog(Widget widget,
      {String type = "right", VoidCallback onDismissListener}) {
    WsyMaterialApp.navigatorController.show(
      widget,
      type,
      alignment: Alignment.centerRight,
      onDismissListener: onDismissListener,
      transition:
          (BuildContext context, Animation<double> animation, Widget child) {
        return _buildRightDialogTransitions(context, animation, child);
      },
    );
  }

//展示bottom弹窗
  static void showBottomDialog(Widget widget,
      {String type = "bottom", VoidCallback onDismissListener}) {
    WsyMaterialApp.navigatorController.show(
      widget,
      type,
      alignment: Alignment.bottomCenter,
      onDismissListener: onDismissListener,
      transition:
          (BuildContext context, Animation<double> animation, Widget child) {
        return _buildBottomDialogTransitions(context, animation, child);
      },
    );
  }

  static void dismissCenterDialog({String type = "center"}) {
    dismissDialog(type);
  }

  static void dismissRightDialog({String type = "right"}) {
    dismissDialog(type);
  }

  static void dismissBottomDialog({String type = "bottom"}) {
    dismissDialog(type);
  }

  static void dismissDialog(String type) {
    WsyMaterialApp.navigatorController.dismiss(type);
  }

  static final Animatable<double> _dialogScaleTween =
      Tween<double>(begin: 1.4, end: 1.0);

  static Widget _buildCupertinoDialogTransitions(
      BuildContext context, Animation<double> animation, Widget child) {
    final CurvedAnimation fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.fastOutSlowIn,
    );
    if (animation.status == AnimationStatus.reverse) {
      return FadeTransition(
        opacity: fadeAnimation,
        child: child,
      );
    }
    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(
        child: child,
        scale: animation.drive(_dialogScaleTween),
      ),
    );
  }

  static Widget _buildRightDialogTransitions(
      BuildContext context, Animation<double> animation, Widget child) {
    var startTween = Tween<Offset>(begin: Offset(1.0, 0), end: Offset.zero);
    final CurvedAnimation fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: Cubic(0.3, 0.7, 0.01, 1.0),
    );
    if (animation.status == AnimationStatus.reverse) {
      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          child: child,
          position: animation.drive(startTween),
        ),
      );
    }
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        child: child,
        position: fadeAnimation.drive(startTween),
      ),
    );
  }

  static Widget _buildBottomDialogTransitions(
      BuildContext context, Animation<double> animation, Widget child) {
    var startTween = Tween<Offset>(begin: Offset(0, 1.0), end: Offset.zero);
    final CurvedAnimation fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: Cubic(0.3, 0.7, 0.01, 1.0),
    );
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        child: child,
        position: fadeAnimation.drive(startTween),
      ),
    );
  }
}

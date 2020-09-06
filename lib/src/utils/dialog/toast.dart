import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dialog.dart';

class ToastUtils {
  static void showError(String text) {
//    show(text, icon: "drive_images/icon_auto_alarm.png");
    show(text,);
  }

  static void showSuccess(String text) {
//    show(text, icon: "drive_images/icon_success.png");
    show(text,);
  }

  static Timer _timer;

  static void show(String text, {String icon}) {
    _timer?.cancel();
    String type = "toast";

    DialogUtils.showCenterDialog(Toast(text: text, icon: icon),
        type: type, tag: text, onDismissListener: () {
      _timer?.cancel();
    });
    _timer = new Timer(Duration(milliseconds: 1500), () {
      dismiss(type: type);
    });
  }

  static void dismiss({String type = "toast"}) {
    DialogUtils.dismissCenterDialog(type: type);
  }
}

///视图
class Toast extends StatelessWidget {
  final String text;
  final String icon;
  final Color textColor =Colors.white;
  final Color backgroundColor = Color(0xcc333333);

  Toast({this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints:BoxConstraints(minWidth: 120),
        padding: EdgeInsets.only(left: 13, right: 13, top: 13, bottom: 14),
        decoration: BoxDecoration(boxShadow: [
          new BoxShadow(
            color: Color(0xff666666), //阴影颜色
            blurRadius: 1.0, //阴影大小
          ),
        ], color: backgroundColor, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            icon == null
                ? SizedBox(
                    width: 1,
                    height: 1,
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: ImageIcon(
                      AssetImage(icon),
                      size: 28,
                      color: textColor,
                    ),
                  ),
            Text("${text}",
                style: TextStyle(
                  inherit: false,
                  fontSize: 14,
                  color: textColor,
                )),
          ],
        ),
      ),
    );
  }
}

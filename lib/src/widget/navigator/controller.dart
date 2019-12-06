import 'package:flutter/material.dart';
import 'view.dart';
import 'widget.dart';

class DialogNavigatorController {
  DialogNavigatorState state;
  VoidCallback refreshCallBack;
  AnimationController animationController;
  Map<String, PopAction> _historyPop = {};
  List<String> _nullContextPop = [];
  List<PopAction> widgets = [];

  bool visible = true;

  void refresh() {
    if (refreshCallBack != null) refreshCallBack();
  }

  static int leftIndex=0;
  ///展示窗体
  void show(Widget widget, String type,
      {Alignment alignment = Alignment.center,
      WsyTransitionBuilder transition,
      VoidCallback onDismissListener,
      String tag = "",
      bool barrierDismissible = false //true隐藏背景，false展示背景
      }) {

    if (state?.context == null) {
      _nullContextPop.add(type);
      Future.delayed(Duration(milliseconds: 2), () {
        show(widget, type,
            alignment: alignment,
            transition: transition,
            onDismissListener: onDismissListener,
            tag: tag,
            barrierDismissible: barrierDismissible);
        _nullContextPop.remove(type);
      });
      return;
    }
    dismiss(type);
    leftIndex++;
    var key=GlobalKey();
    var popAction = PopAction(widget,key, type,
        alignment: alignment,
        transition: transition,
        tag: tag,
        onDismissListener: onDismissListener,
        barrierDismissible: barrierDismissible);

    ///整理位置
    if (type == "toast") {
      widgets.insert(0, popAction);
    } else if (type == "loading") {
      if (_historyPop.containsKey("toast") && widgets.length > 0) {
        widgets.insert(1, popAction);
      } else {
        widgets.insert(0, popAction);
      }
    } else {
      widgets.add(popAction);
    }
    _historyPop[type] = popAction;

    refresh();
  }

  void startToDismiss(String type) {
    if (_historyPop.containsKey(type)) {
      var popAction = _historyPop[type];
      _historyPop.remove(type);
//      popAction.isDismiss = true;
      widgets.remove(popAction);
      if (popAction.onDismissListener != null){
        popAction.onDismissListener();
        popAction.isDismissCall=true;
      }
      refresh();
    }
  }

  //销毁窗体
  void dismiss(String type) {
    if(state?.context == null||_nullContextPop.contains(type)){
      Future.delayed(Duration(milliseconds: 10),(){
        dismiss(type);
      });
      return;
    }

    if (_historyPop.containsKey(type)) {
      var popAction = _historyPop[type];
      _historyPop.remove(type);
      popAction.isDismiss = true;

      if (popAction.onDismissListener != null) {
        popAction.onDismissListener();
        popAction.isDismissCall=true;
      }
      refresh();
    }else{
      for(int i=0;i<widgets.length;i++){
        PopAction popAction = widgets[i];
        if(!_historyPop.containsValue(popAction)){
          popAction.isDismiss=true;
          if (popAction.onDismissListener != null){
            popAction.onDismissListener();
            popAction.isDismissCall=true;
          }
          refresh();
        }
      }
    }


  }

  //弹窗销毁回调
  void onDismissListener(PopAction item) {
    if(!item.isDismissCall){
      if(item?.onDismissListener!=null) {
        item?.onDismissListener();
      }
    }
    widgets.remove(item);
    refresh();
  }

  ///安卓回退按键
  ///关掉最后一个弹窗
  bool backPressed() {
    var endWidget;
    for(int i=widgets.length-1;i>=0;i--){
      var widget=widgets[i];
      if(widget.type!="toast"&&!widget.isDismiss){
        endWidget=widget;
        break;
      }

    }
    if(endWidget==null){
      return false;
    }
    String endKey = "";
    for (var key in _historyPop.keys) {
      var value = _historyPop[key];
      if (value == endWidget) {
        endKey = key;
        break;
      }
    }

    if(endKey==""||endKey==null){
      return false;
    }
    dismiss(endKey);
    return true;
  }
}

//存储维护生命周期
class PopAction {
  final Widget child;
  final String type;
  final Alignment alignment;
  final String tag;
  final GlobalKey key;
  final WsyTransitionBuilder transition;
  final VoidCallback onDismissListener;
  final bool barrierDismissible; //true隐藏背景，false展示背景

  PopAction(this.child, this.key, this.type,
      {this.alignment = Alignment.center,
      this.transition,
      this.tag,
      this.onDismissListener,
      this.barrierDismissible = false});

  bool isDismiss = false;
  bool isDismissCall = false;
}

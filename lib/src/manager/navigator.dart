import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///获取当前界面的名称
class DriveNavigatorManager extends NavigatorObserver {
  String currentWidgetName = "/";
  static DriveNavigatorManager manager = DriveNavigatorManager();

  List<Route<dynamic>> _historyRoute = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) async {
    if (previousRoute is MaterialPageRoute) {
      _changePauseListenerByElement(previousRoute.subtreeContext as Element,VisitorElement());
    } else if (previousRoute is CupertinoPageRoute) {
      _changePauseListenerByElement(previousRoute.subtreeContext as Element,VisitorElement());
    }
    _historyRoute.add(route);
    _getRunType(route);
  }

  void _getRunType(Route<dynamic> route) {
    String runtimeType = "";
    Widget widget;

    if (route is MaterialPageRoute) {
      var w = route.buildPage(
          route.subtreeContext, route.animation, route.secondaryAnimation);
      widget = (w as Semantics).child;
//      didELement(route.subtreeContext);
    } else if (route is CupertinoPageRoute) {
      widget = route.builder(null);
    }
    runtimeType = widget.runtimeType.toString();
    currentWidgetName = runtimeType;
  }

//  void didELement(BuildContext context) {
////    print("start:${context}");
//    var element = context as Element;
//    _changeListenerByElement(element);
//  }

  void _changeResumeListenerByElement(Element element,VisitorElement visitor) {
    if(!visitor.isRun){
      return;
    }
    try {
      element?.visitChildren((v) {
        if (v != null) {
          if (v is StatefulElement) {
            if (v.state is OnAppLifecycleListener) {
              var bing = v.state as OnAppLifecycleListener;
              visitor.isRun=false;
              bing.onResume();
            }
          }
        }
        _changeResumeListenerByElement(v,visitor);
      });
    } catch (e) {
      print(e);
    }
  }
  void _changePauseListenerByElement(Element element,VisitorElement visitor) {
    if(!visitor.isRun){
      return;
    }
    try {
      element?.visitChildren((v) {
        if (v != null) {
          if (v is StatefulElement) {
            if (v.state is OnAppLifecycleListener) {
              var bing = v.state as OnAppLifecycleListener;
              bing.onPause();
              //结束继续遍历
              visitor.isRun=false;
            }
          }
        }
        _changePauseListenerByElement(v,visitor);
      });
    } catch (e) {
      print(e);
    }
  }

  void popAllAndPush(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 300));
    List<Route<dynamic>> popRoute = [];
    for (int i = 1; i < _historyRoute.length-1; i++) {
      Route<dynamic> value = _historyRoute[i];
      popRoute.add(value);
      if (value is MaterialPageRoute) {
        Navigator.of(value.subtreeContext).removeRoute(value);
      }
    }

    for (var route in popRoute) {
      if (_historyRoute.contains(route))
        _historyRoute.remove(route);
    }
  }


  void _changeListener(Element element, int index) {
    try {
      element?.visitChildren((v) {
        if (v != null) {
          if (v is StatefulElement) {
            if (index >= 25 && index < 35)
              print("_changeListener-${index}:${v.widget}");
          }
        }
        _changeListener(v, index + 1);
      });
    } catch (e) {
      print(e);
    }
  }

  void printElement(BuildContext context) {
    var e = Navigator
        .of(context)
        .context as Element;
    _changeListener(e, 0);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    _historyRoute.remove(route);
    _getRunType(previousRoute);
    if (previousRoute is MaterialPageRoute) {
      _changeResumeListenerByElement(previousRoute.subtreeContext as Element,VisitorElement());
    } else if (previousRoute is CupertinoPageRoute) {
      _changeResumeListenerByElement(previousRoute.subtreeContext as Element,VisitorElement());
    }
  }
}

class VisitorElement{
  bool isRun=true;
}

//typedef OnStateListener=Function(int);
mixin OnAppLifecycleListener {
  void onResume(){}
  void onPause(){}
}

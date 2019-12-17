import 'dart:async';

import 'package:drive/drive.dart';
import 'package:drive/src/base/page/widget.dart';
import 'package:drive/src/manager/navigator.dart';
import 'package:drive/src/utils/dialog/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loading.dart';

class ControllerWidget<T extends BaseController> extends StatelessWidget{
  T controller;
  final Widget Function(T controller) builder;
  ControllerWidget({this.builder});
  @override
  Widget build(BuildContext context) {
    if(controller==null){
      controller=ControllerInherited.of(context).controller;
    }
    return builder(controller);
  }

}

class Stateful extends StatefulWidget {
  final String k;
  final List<dynamic> Function() bind;
  final WidgetBuilder builder;

  Stateful({this.k, this.bind, @required this.builder});

  @override
  _StatefulState createState() => _StatefulState();
}

class _StatefulState extends State<Stateful> {
  BaseController controller;
  List<dynamic> oldDiffs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      var inherited = ControllerInherited.of(context);
      controller = inherited.controller;


      if (widget.bind != null) {
        oldDiffs = widget.bind();
        controller._addState(this);
      }
      if(widget.k!=null){
        controller._addState(this,k:widget.k);
      }
    });
  }

  @override
  void didUpdateWidget(Stateful oldWidget) {
    if (widget.bind != null) {
      oldDiffs = widget.bind();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _refresh(List<dynamic> diffs) {
    oldDiffs = diffs;
    setState(() {
    });
  }

  void setDiffState() {
    var diffs = widget.bind();
    if (oldDiffs== null) {
      _refresh(diffs);
      return;
    }
    if(_listDiff(diffs,oldDiffs)){
      _refresh(diffs);
    }
  }
  ///对比list是否一样
  bool _listDiff(List newList, List oldList) {
    if (newList.length != oldList.length) {
      return true;
    }
    if (newList == oldList) {
      return false;
    }
    var diffs = newList;
    var oldDiffs = oldList;
    for (int i = 0; i < diffs.length; i++) {
      if (_diffValue(diffs[i], oldDiffs[i])) {
        return true;
      }
    }
    return false;
  }

  ///对比map是否一样
  bool _mapDiff(Map newMap, Map oldMap) {
    if (newMap.length != oldMap.length) {
      return true;
    }
    if (newMap == oldMap) {
      return false;
    }
    var newKey = newMap.keys;
    for (var key in newKey) {
      if(!oldMap.containsKey(key)){
        return true;
      }
      if (_diffValue(newMap[key], oldMap[key])) {
        return true;
      }
      oldMap.remove(key);
    }
    if(oldMap.length>0){
      return true;
    }
    return false;
  }

  ///对比值是否一样
  bool _diffValue(dynamic newValue, dynamic oldValue) {
    if (newValue.runtimeType != oldValue.runtimeType) {
      return true;
    }
    if (newValue is List) {
      if (_listDiff(newValue, oldValue)) {
        return true;
      }
    }
    if (newValue is Map) {
      if (_mapDiff(newValue, oldValue)) {
        return true;
      }
    }
    if (newValue != oldValue) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    controller._removeState(state: this);
    controller._removeState(k:widget.k);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}

abstract class BasePage<T extends BaseController> {
  __PageWidgetState _state;
  BaseController _controller;
  Widget get widget{
    return _createWidget();
  }

  T get controller => _controller;
  T get c => _controller;
  LoadingController _loadingController = new LoadingController();

  BuildContext get context => _state?.context;

  void _registerState(__PageWidgetState state) {
    this._state = state;
    if (_controller != null) {
      _controller._registerState(state);
    }
  }

  void _registerController(BaseController controller) {
    this._controller = controller;
    controller._loadingController = _loadingController;
    if (_state != null) {
      controller._registerState(_state);
    }
  }

  @protected
  void setState(VoidCallback fun) {
    if (_state == null) {
      return;
    }
    if (_state.mounted) {
      _state?.setState(fun);
    }
  }

  Widget _createWidget() {
    return _PageWidget(this);
  }

  @protected
  @mustCallSuper
  void initState() {}

  @protected
  @mustCallSuper
  void onResume() {}

  @protected
  @mustCallSuper
  void onPause() {}

  @protected
  @mustCallSuper
  void dispose() {}

  @protected
  Widget build(BuildContext context);
}

class _PageWidget extends StatefulWidget {
  final BasePage basePage;

  _PageWidget(this.basePage);

  @override
  __PageWidgetState createState() => __PageWidgetState();
}

class __PageWidgetState extends State<_PageWidget> with OnAppLifecycleListener {
  BasePage basePage;

  @override
  void initState() {
    this.basePage = widget.basePage;
    basePage._registerState(this);
    basePage.initState();
    super.initState();
  }

  void showLoading({String text}) {}

  void dismissLoading() {}

  @override
  void onResume() {
    basePage.onResume();
    basePage._controller?.resume();
    super.onResume();
  }

  @override
  void onPause() {
    basePage.onPause();
    basePage._controller?.pause();
    super.onPause();
  }

  @override
  void dispose() {
    basePage.dispose();
    basePage._controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ControllerInherited(
            controller: basePage.controller, child: basePage.build(context)),
        Visibility(
            child: LoadingDialog(
          controller: basePage._loadingController,
        ))
      ],
    );
  }
}

class BasePageRoute extends MaterialPageRoute {
  BasePageRoute({
    @required BasePageRouteBuilder build,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: (context) {
              return build(context).widget;
            },
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog);
}

typedef BasePageRouteBuilder = BasePage Function(BuildContext context);

class BaseController {
  BaseController(this.page) {
    page._registerController(this);
//    _startPage();
  }

  __PageWidgetState _state;
  BasePage page;


  ///菊花圈控制器
  LoadingController _loadingController;

  BuildContext get context => _state?.context;

  ///局部刷新数组
  Map<String, _StatefulState> _mapStates = {};
  List<_StatefulState> _listState =[];
  ///判断是否点击第一次
  List<String> _isTap=[];

  bool _isFirstTime = true;

  //防误触
  Timer _timer;
  ///防误触摸
  void accidentPrevention(bool isFirstTime,VoidCallback callback,{Duration duration=const Duration(milliseconds: 300)}){
    if(isFirstTime){
      callback();
    }else{
      _timer?.cancel();
      _timer=Timer(duration, callback);
    }
  }

  ///添加局部刷新
  void _addState(_StatefulState state,{String k}) {
    ///判断是对比差别方式还是key方式
    if(k==null){
      if(!_listState.contains(state)){
        _listState.add(state);
      }
    }else {
      _removeState(k:k);
      _mapStates[k] = state;
    }
  }

  ///删除局部刷新
  void _removeState({String k,_StatefulState state}) {
    if(k!=null){
      if (_mapStates.containsKey(k)) {
        _mapStates.remove(k);
      }
    }else if(state!=null){
      if(_listState.contains(state)){
        _listState.remove(state);
      }
    }
  }

  void _registerState(__PageWidgetState state) {
    this._state = state;
    initState();
  }

  Future<dynamic> push(BuildContext context) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) {
      return page.widget;
    }));
  }

  ///刷新
  void setState({String k}) {
    if (k != null) {
      if (_mapStates.containsKey(k)) {
        _setState(_mapStates[k]);
      }
    }else{
      for (var value in _listState) {
        value.setDiffState();
      }
    }
  }

  void setRootState(){
    _setState(_state);
  }

  void _setState(State state) {
    try {
      if (state?.mounted) {
        state?.setState(() {});
      }
    } catch (e) {
      print(e);
      Future.delayed(Duration(milliseconds: 50), () {
        _setState(state);
      });
    }
  }

  void initState() {}

  void resume() {}

  void pause() {}

  void dispose() {
    _isFirstTime = true;
    _timer?.cancel();
  }

  void showLoading({String text}) {
    _loadingController.showLoading();
  }

  void dismissLoading() {
    _loadingController.dismissLoading();
  }

}

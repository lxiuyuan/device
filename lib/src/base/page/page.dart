import 'package:drive/drive.dart';
import 'package:drive/src/base/page/widget.dart';
import 'package:drive/src/manager/navigator.dart';
import 'package:drive/src/utils/dialog/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loading.dart';

class Stateful extends StatefulWidget {
  final String k;
  final WidgetBuilder builder;
  Stateful({@required this.k,@required this.builder});
  @override
  _StatefulState createState() => _StatefulState();
}

class _StatefulState extends State<Stateful> {
  BaseController controller;
  @override
  void initState() {

    super.initState();
    Future.delayed(Duration(milliseconds: 100),(){
      var inherited=ControllerInherited.of(context);
      controller=inherited.controller;
      controller._addState(widget.k, this);
    });
  }

  @override
  void dispose() {
    controller._removeState(widget.k);
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
  T get controller =>_controller;
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

  Widget createWidget() {
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
    basePage._controller?.onResume();
    super.onResume();
  }

  @override
  void onPause() {
    basePage.onPause();
    basePage._controller?.onPause();
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
        ControllerInherited(controller: basePage.controller,child: basePage.build(context)),
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
              return build(context).createWidget();
            },
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog);
}

typedef BasePageRouteBuilder = BasePage Function(BuildContext context);

class BaseController {
  BaseController(BasePage page){
    _page=page;
    _page._registerController(this);
//    _startPage();
  }
  __PageWidgetState _state;
  BasePage _page;
  ///菊花圈控制器
  LoadingController _loadingController;

  BuildContext get context => _state?.context;

  ///局部刷新数组
  Map<String,State> _states={};
  ///添加局部刷新
  void _addState(String k,State state){
    _removeState(k);
    _states[k]=state;
  }
  ///删除局部刷新
  void _removeState(String k){
    if(_states.containsKey(k)){
      _states.remove(k);
    }
  }

  void _registerState(__PageWidgetState state) {
    this._state = state;
    initState();
  }

  Future<dynamic> push() async {
    await Navigator.of(WsyMaterialApp.context).push(MaterialPageRoute(builder: (context){
      return _page.createWidget();
    }));
  }



  ///刷新
  void setState({String k}) {
    State state=_state;
    if(k!=null) {
      if (_states.containsKey(k)) {
        state = _states[k];
      }
    }
    _setState(state);
  }

  void _setState(State state){
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

  void onResume() {}

  void onPause() {}

  void dispose() {}

  void showToastError(String toast) {
    ToastUtils.showError(toast);
  }

  void showToastSuccess(String toast) {
    ToastUtils.showSuccess(toast);
  }

  void showLoading({String text}) {
    _loadingController.showLoading();
  }

  void dismissLoading() {
    _loadingController.dismissLoading();
  }

  void showBottomDialog(Widget widget) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Color(0x66000000),
        transitionDuration: Duration(milliseconds: 400),
        barrierLabel: "bottomDialog",
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          var startTween = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero);
          final CurvedAnimation fadeAnimation = CurvedAnimation(
            parent: animation,
            curve: Cubic(0.3, 0.7, 0.01, 1.0),
          );
          return SlideTransition(position: fadeAnimation.drive(startTween),child: Container(alignment: Alignment.bottomCenter, child: widget));
        });

  }
}


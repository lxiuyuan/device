import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';


const double pi = 3.1415926535897932;
const double fontSize = 14;
const double iconSize = 16;

class WsyFooter extends Footer {
  /// Key
  final Key key;

  /// 方位
  final AlignmentGeometry alignment;

  /// 提示加载文字
  final String loadText;

  /// 准备加载文字
  final String loadReadyText;

  /// 正在加载文字
  final String loadingText;

  /// 加载完成文字
  final String loadedText;

  /// 加载失败文字
  final String loadFailedText;

  /// 没有更多文字
  final String noMoreText;

  /// 显示额外信息(默认为时间)
  final bool showInfo;

  /// 更多信息
  final String infoText;

  /// 背景颜色
  final Color bgColor;

  /// 字体颜色
  final Color textColor;

  /// 更多信息文字颜色
  final Color infoColor;

  WsyFooter({
    extent = 60.0,
    triggerDistance = 70.0,
    float = false,
    completeDuration = const Duration(seconds: 1),
    enableInfiniteLoad = true,
    enableHapticFeedback = true,
    this.key,
    this.alignment,
    this.loadText: "Push to load",
    this.loadReadyText: "Release to load",
    this.loadingText: "Loading...",
    this.loadedText: "Load completed",
    this.loadFailedText: "Load failed",
    this.noMoreText: "No more",
    this.showInfo: true,
    this.infoText: "Updated at %T",
    this.bgColor: Colors.transparent,
    this.textColor: Colors.black,
    this.infoColor: Colors.teal,
  }) : super(
    extent: extent,
    triggerDistance: triggerDistance,
    float: float,
    completeDuration: completeDuration,
    enableInfiniteLoad: enableInfiniteLoad,
    enableHapticFeedback: enableHapticFeedback,
  );

  @override
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    return WsyFooterWidget(
      key: key,
      wsyFooter: this,
      loadState: loadState,
      pulledExtent: pulledExtent,
      loadTriggerPullDistance: loadTriggerPullDistance,
      loadIndicatorExtent: loadIndicatorExtent,
      axisDirection: axisDirection,
      float: float,
      completeDuration: completeDuration,
      enableInfiniteLoad: enableInfiniteLoad,
      success: success,
      noMore: noMore,
    );
  }
}

class WsyFooterWidget extends StatefulWidget {
  final WsyFooter wsyFooter;
  final LoadMode loadState;
  final double pulledExtent;
  final double loadTriggerPullDistance;
  final double loadIndicatorExtent;
  final AxisDirection axisDirection;
  final bool float;
  final Duration completeDuration;
  final bool enableInfiniteLoad;
  final bool success;
  final bool noMore;

  WsyFooterWidget(
      {Key key,
        this.loadState,
        this.wsyFooter,
        this.pulledExtent,
        this.loadTriggerPullDistance,
        this.loadIndicatorExtent,
        this.axisDirection,
        this.float,
        this.completeDuration,
        this.enableInfiniteLoad,
        this.success,
        this.noMore})
      : super(key: key);

  @override
  WsyFooterWidgetState createState() => WsyFooterWidgetState();
}

class WsyFooterWidgetState extends State<WsyFooterWidget>
    with TickerProviderStateMixin<WsyFooterWidget> {
  // 是否到达触发加载距离
  bool _overTriggerDistance = false;
  bool get overTriggerDistance => _overTriggerDistance;
  set overTriggerDistance(bool over) {
    if (_overTriggerDistance != over) {
      _overTriggerDistance
          ? _readyController.forward()
          : _restoreController.forward();
    }
    _overTriggerDistance = over;
  }

  // 动画
  AnimationController _readyController;
  Animation<double> _readyAnimation;
  AnimationController _restoreController;
  Animation<double> _restoreAnimation;

  // Icon旋转度
  double _iconRotationValue = 1.0;

  // 显示文字
  String get _showText {
    if (widget.noMore) return widget.wsyFooter.noMoreText;
    if (widget.enableInfiniteLoad) {
      if (widget.loadState == LoadMode.loaded ||
          widget.loadState == LoadMode.inactive ||
          widget.loadState == LoadMode.drag) {
        return widget.wsyFooter.loadedText;
      } else {
        return widget.wsyFooter.loadingText;
      }
    }
    switch (widget.loadState) {
      case LoadMode.load:
        return widget.wsyFooter.loadingText;
      case LoadMode.armed:
        return widget.wsyFooter.loadingText;
      case LoadMode.loaded:
        return _finishedText;
      case LoadMode.done:
        return _finishedText;
      default:
        if (overTriggerDistance) {
          return widget.wsyFooter.loadReadyText;
        } else {
          return widget.wsyFooter.loadText;
        }
    }
  }

  // 加载结束文字
  String get _finishedText {
    if (!widget.success) return widget.wsyFooter.loadFailedText;
    if (widget.noMore) return widget.wsyFooter.noMoreText;
    return widget.wsyFooter.loadedText;
  }

  // 加载结束图标
  IconData get _finishedIcon {
    if (!widget.success) return Icons.error_outline;
    if (widget.noMore) return null;
    return Icons.done;
  }

  // 更新时间
  DateTime _dateTime;
  // 获取更多信息
  String get _infoText {
    if (widget.loadState == LoadMode.loaded) {
      _dateTime = DateTime.now();
    }
    String fillChar = _dateTime.minute < 10 ? "0" : "";
    return widget.wsyFooter.infoText
        .replaceAll("%T", "${_dateTime.hour}:$fillChar${_dateTime.minute}");
  }

  @override
  void initState() {
    super.initState();
    // 初始化时间
    _dateTime = DateTime.now();
    // 初始化动画
    _readyController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _readyAnimation = new Tween(begin: 0.5, end: 1.0).animate(_readyController)
      ..addListener(() {
        setState(() {
          if (_readyAnimation.status != AnimationStatus.dismissed) {
            _iconRotationValue = _readyAnimation.value;
          }
        });
      });
    _readyAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _readyController.reset();
      }
    });
    _restoreController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _restoreAnimation =
    new Tween(begin: 1.0, end: 0.5).animate(_restoreController)
      ..addListener(() {
        setState(() {
          if (_restoreAnimation.status != AnimationStatus.dismissed) {
            _iconRotationValue = _restoreAnimation.value;
          }
        });
      });
    _restoreAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _restoreController.reset();
      }
    });
  }

  @override
  void dispose() {
    _readyController.dispose();
    _restoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 是否为垂直方向
    bool isVertical = widget.axisDirection == AxisDirection.down ||
        widget.axisDirection == AxisDirection.up;
    // 是否反向
    bool isReverse = widget.axisDirection == AxisDirection.up ||
        widget.axisDirection == AxisDirection.left;
    // 是否到达触发加载距离
    overTriggerDistance = widget.loadState != LoadMode.inactive &&
        widget.pulledExtent >= widget.loadTriggerPullDistance;
    return Stack(
      children: <Widget>[
        Positioned(
          top: !isVertical ? 0.0 : !isReverse ? 0.0 : null,
          bottom: !isVertical ? 0.0 : isReverse ? 0.0 : null,
          left: isVertical ? 0.0 : !isReverse ? 0.0 : null,
          right: isVertical ? 0.0 : isReverse ? 0.0 : null,
          child: Container(
            alignment: widget.wsyFooter.alignment ?? isVertical
                ? !isReverse ? Alignment.topCenter : Alignment.bottomCenter
                : isReverse ? Alignment.centerRight : Alignment.centerLeft,
            width: !isVertical
                ? widget.loadIndicatorExtent > widget.pulledExtent
                ? widget.loadIndicatorExtent
                : widget.pulledExtent
                : double.infinity,
            height: isVertical
                ? widget.loadIndicatorExtent > widget.pulledExtent
                ? widget.loadIndicatorExtent
                : widget.pulledExtent
                : double.infinity,
            color: widget.wsyFooter.bgColor,
            child: SizedBox(
              height: isVertical ? widget.loadIndicatorExtent : double.infinity,
              width: !isVertical ? widget.loadIndicatorExtent : double.infinity,
              child: isVertical
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildContent(isVertical, isReverse),
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildContent(isVertical, isReverse),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 构建显示内容
  List<Widget> _buildContent(bool isVertical, bool isReverse) {
    return isVertical
        ? <Widget>[
//      Expanded(
//        flex: 2,
//        child:
//      ),
      Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(
          right: 10.0,
        ),
        child: (widget.loadState == LoadMode.load ||
            widget.loadState == LoadMode.armed) && !widget.noMore
            ? Container(
          width: iconSize,
          height: iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation(
              widget.wsyFooter.textColor,
            ),
          ),
        )
            : widget.loadState == LoadMode.loaded ||
            widget.loadState == LoadMode.done ||
            (widget.enableInfiniteLoad &&
                widget.loadState != LoadMode.loaded) ||
            widget.noMore
            ? (_finishedIcon==null ? null :
        Icon(
          _finishedIcon,
          size: iconSize,
          color: widget.wsyFooter.textColor,
        ))
            : Transform.rotate(
          child: Icon(
            !isReverse
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            size: iconSize,
            color: widget.wsyFooter.textColor,
          ),
          angle: 2 * pi * _iconRotationValue,
        ),
      ),
//      Expanded(
//        flex: 3,
//        child:
//      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _showText,
            style: TextStyle(
              fontSize: _finishedIcon==null ? 12 : fontSize,
              color: widget.wsyFooter.textColor,
            ),
          ),
          widget.wsyFooter.showInfo
              ? Container(
            margin: EdgeInsets.only(
              top: 2.0,
            ),
            child: Text(
              _infoText,
              style: TextStyle(
                fontSize: _finishedIcon==null ? 12 : fontSize,
                color: widget.wsyFooter.infoColor,
              ),
            ),
          )
              : Container(),
        ],
      ),
//      Expanded(
//        flex: 2,
//        child: SizedBox(),
//      ),
    ]
        : <Widget>[
      Container(
        child: widget.loadState == LoadMode.load ||
            widget.loadState == LoadMode.armed
            ? Container(
          width: iconSize,
          height: iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation(
              widget.wsyFooter.textColor,
            ),
          ),
        )
            : widget.loadState == LoadMode.loaded ||
            widget.loadState == LoadMode.done ||
            (widget.enableInfiniteLoad &&
                widget.loadState != LoadMode.loaded) ||
            widget.noMore
            ? (_finishedIcon==null ? null :
        Icon(
          _finishedIcon,
          size: iconSize,
          color: widget.wsyFooter.textColor,
        ))
            : Transform.rotate(
          child: Icon(
            !isReverse ? Icons.arrow_back : Icons.arrow_forward,
            color: widget.wsyFooter.textColor,
            size: iconSize,
          ),
          angle: 2 * pi * _iconRotationValue,
        ),
      ),
    ];
  }
}


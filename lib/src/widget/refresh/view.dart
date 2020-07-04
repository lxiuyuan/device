import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'footer.dart';

import 'header.dart';

class WsyRefresh extends EasyRefresh {
  /// custom构造器(推荐)
  /// 直接使用CustomScrollView可用的slivers
  WsyRefresh.custom({
    Key key,
    WsyRefreshController controller,
    OnRefreshCallback onRefresh,
    OnLoadCallback onLoad,
    bool enableControlFinishRefresh = false,
    bool enableControlFinishLoad = false,
    bool taskIndependence = false,
    WsyClassicalHeader header,
    int headerIndex,
    WsyClassicalFooter footer,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController scrollController,
    bool primary,
    bool shrinkWrap = false,
    Key center,
    double anchor = 0.0,
    double cacheExtent,
    int semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    bool firstRefresh,
    Widget firstRefreshWidget,
    Widget emptyWidget,
    bool topBouncing = true,
    bool bottomBouncing = true,
    @required List<Widget> slivers,
  }) : super.custom(
      key: key,
      controller: controller,
      onRefresh: onRefresh,
      onLoad: onLoad,
      enableControlFinishRefresh: enableControlFinishRefresh,
      enableControlFinishLoad: enableControlFinishLoad,
      taskIndependence: taskIndependence,
      header: header ?? WsyClassicalHeader(),
      headerIndex: headerIndex,
      footer: footer ?? WsyClassicalFooter(),
      scrollDirection: scrollDirection,
      reverse: reverse,
      scrollController: scrollController,
      primary: primary,
      shrinkWrap: shrinkWrap,
      center: center,
      anchor: anchor,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      dragStartBehavior: dragStartBehavior,
      firstRefresh: firstRefresh,
      firstRefreshWidget: firstRefreshWidget,
      emptyWidget: emptyWidget,
      topBouncing: topBouncing,
      bottomBouncing: bottomBouncing,
      slivers: slivers);

  /// 自定义构造器
  /// 用法灵活,但需将physics、header和footer放入列表中
  WsyRefresh.builder({
    key,
    WsyRefreshController controller,
    OnRefreshCallback onRefresh,
    OnLoadCallback onLoad,
    bool enableControlFinishRefresh = false,
    bool enableControlFinishLoad = false,
    bool taskIndependence = false,
    ScrollController scrollController,
    WsyClassicalHeader header,
    WsyClassicalFooter footer,
    bool firstRefresh,
    Widget emptyWidget,
    bool topBouncing = true,
    bool bottomBouncing = true,
    int childCount,
    @required IndexedWidgetBuilder builder,
  }) : this.custom(
      key: key,
      controller: controller,
      onRefresh: onRefresh,
      emptyWidget: emptyWidget,
      onLoad: onLoad,
      enableControlFinishLoad: enableControlFinishLoad,
      enableControlFinishRefresh: enableControlFinishRefresh,
      taskIndependence: taskIndependence,
      scrollController: scrollController,
      header: header ?? WsyClassicalHeader(),
      footer: footer ?? WsyClassicalFooter(),
      firstRefresh: firstRefresh,
      topBouncing: topBouncing,
      bottomBouncing: bottomBouncing,
      slivers: [
        SliverList(
          delegate:
          SliverChildBuilderDelegate(builder, childCount: childCount),
        )
      ]);

  /// 自定义构造器
  /// 用法灵活,但需将physics、header和footer放入列表中
  WsyRefresh.grid({
    key,
    WsyRefreshController controller,
    OnRefreshCallback onRefresh,
    OnLoadCallback onLoad,
    bool enableControlFinishRefresh = false,
    bool enableControlFinishLoad = false,
    bool taskIndependence = false,
    int crossAxisCount,
    double mainAxisSpacing = 0,
    double crossAxisSpacing = 0,
    double childAspectRatio = 1,
    ScrollController scrollController,
    WsyClassicalHeader header,
    WsyClassicalFooter footer,
    Widget emptyWidget,
    bool firstRefresh,
    bool topBouncing = true,
    bool bottomBouncing = true,
    EdgeInsetsGeometry padding,
    int childCount,
    @required IndexedWidgetBuilder builder,
  }) : this.custom(
      key: key,
      controller: controller,
      onRefresh: onRefresh,
      onLoad: onLoad,
      enableControlFinishLoad: enableControlFinishLoad,
      enableControlFinishRefresh: enableControlFinishRefresh,
      taskIndependence: taskIndependence,
      scrollController: scrollController,
      header: header,
      footer: footer ?? WsyClassicalFooter(),
      firstRefresh: firstRefresh,
      topBouncing: topBouncing,
      bottomBouncing: bottomBouncing,
      emptyWidget: emptyWidget,
      slivers: [
        padding == null ?
        SliverGrid(
            delegate: SliverChildBuilderDelegate(builder,
                childCount: childCount),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
                childAspectRatio: childAspectRatio)) :
        SliverPadding(padding: padding, sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(builder,
                childCount: childCount),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
                childAspectRatio: childAspectRatio)))
      ]);
}

class WsyClassicalHeader extends WsyHeader {
  WsyClassicalHeader({
    double extent = 60.0,
    double triggerDistance = 70.0,
    bool float = false,
    Duration completeDuration = const Duration(milliseconds: 0),
    bool enableInfiniteRefresh = false,
    bool enableHapticFeedback = false,
    Key key,
    AlignmentGeometry alignment,
    String refreshText = "下拉刷新",
    String refreshReadyText = "松手刷新",
    String refreshingText = "刷新中...",
    String refreshedText = "刷新完成",
    String refreshFailedText = "刷新失败",
    String noMoreText = "No more",
    bool showInfo = false,
    String infoText = "",
    Color bgColor = Colors.transparent,
    Color textColor = Colors.grey,
    Color infoColor = Colors.grey,
  }) : super(
      extent: extent,
      triggerDistance: triggerDistance,
      float: float,
      completeDuration: completeDuration,
      enableInfiniteRefresh: enableInfiniteRefresh,
      enableHapticFeedback: enableHapticFeedback,
      key: key,
      alignment: alignment,
      refreshText: refreshText,
      refreshReadyText: refreshReadyText,
      refreshingText: refreshingText,
      refreshedText: refreshedText,
      refreshFailedText: refreshFailedText,
      noMoreText: noMoreText,
      showInfo: showInfo,
      infoText: infoText,
      bgColor: bgColor,
      textColor: textColor,
      infoColor: infoColor);
}

class WsyClassicalFooter extends WsyFooter {
  WsyClassicalFooter({
    double extent = 60.0,
    double triggerDistance = 70.0,
    bool float = false,
    Duration completeDuration = const Duration(milliseconds: 0),
    bool enableInfiniteLoad = true,
    bool enableHapticFeedback = false,
    Key key,
    AlignmentGeometry alignment,
    String loadText = "加载更多",
    String loadReadyText = "加载更多",
    String loadingText = "正在加载...",
    String loadedText = "加载完成",
    String loadFailedText = "加载失败",
    String noMoreText = "—— 我是有底线的 ——",
    bool showInfo: false,
    String infoText = "",
    Color bgColor = Colors.transparent,
    Color textColor = Colors.grey,
    Color infoColor = Colors.teal,
  }) : super(
    extent: extent,
    triggerDistance: triggerDistance,
    float: float,
    completeDuration: completeDuration,
    enableInfiniteLoad: enableInfiniteLoad,
    enableHapticFeedback: enableHapticFeedback,
    key: key,
    alignment: alignment,
    loadText: loadText,
    loadReadyText: loadReadyText,
    loadingText: loadingText,
    loadedText: loadedText,
    loadFailedText: loadFailedText,
    noMoreText: noMoreText,
    showInfo: showInfo,
    infoText: infoText,
    bgColor: bgColor,
    textColor: textColor,
    infoColor: infoColor,
  );
}

class WsyRefreshController extends EasyRefreshController {}

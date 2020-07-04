import 'package:flutter/material.dart';
import 'package:drive/src/manager/navigator.dart';
import 'package:drive/src/utils/sp.dart';

import 'navigator/view.dart';

class MvcMaterialApp extends MaterialApp {
  static DialogNavigatorController navigatorController =
      DialogNavigatorController();
  static BuildContext context;

  MvcMaterialApp({
    Key key,
    GlobalKey<NavigatorState> navigatorKey,
    Widget home,
    Map<String, WidgetBuilder> routes = const <String, WidgetBuilder>{},
    String initialRoute,
    RouteFactory onGenerateRoute,
    RouteFactory onUnknownRoute,
    List<NavigatorObserver> navigatorObservers,
    TransitionBuilder builder,
    String title = '',
    GenerateAppTitle onGenerateTitle,
    Color color,
    ThemeData theme,
    ThemeData darkTheme,
    ThemeMode themeMode = ThemeMode.system,
    Locale locale,
    Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    LocaleListResolutionCallback localeListResolutionCallback,
    LocaleResolutionCallback localeResolutionCallback,
    Iterable<Locale> supportedLocales = const <Locale>[Locale('en', 'US')],
    bool debugShowMaterialGrid = false,
    bool showPerformanceOverlay = false,
    bool checkerboardRasterCacheImages = false,
    bool checkerboardOffscreenLayers = false,
    bool showSemanticsDebugger = false,
    bool debugShowCheckedModeBanner = true,
  }) : super(
          key: key,
          navigatorKey: navigatorKey,
          home: home,
          routes: routes,
          initialRoute: initialRoute,
          onGenerateRoute: onGenerateRoute,
          onUnknownRoute: onUnknownRoute,
          navigatorObservers: <NavigatorObserver>[
            DriveNavigatorManager.manager
          ],
          builder: (context, child) {
//            WsyMaterialApp.context=context;
            if (child == null) {
              return null;
            }
            var widget = Stack(
              children: <Widget>[
                child,
                DialogNavigator(
                  controller: navigatorController,
                )
              ],
            );
            if (builder == null) {
              return widget;
            } else {
              return builder(context, widget);
            }
          },
          title: title,
          onGenerateTitle: onGenerateTitle,
          color: color,
          theme: theme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          locale: locale,
          localizationsDelegates: localizationsDelegates,
          localeListResolutionCallback: localeListResolutionCallback,
          localeResolutionCallback: localeResolutionCallback,
          supportedLocales: supportedLocales,
          debugShowMaterialGrid: debugShowMaterialGrid,
          showPerformanceOverlay: showPerformanceOverlay,
          checkerboardRasterCacheImages: checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: checkerboardOffscreenLayers,
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        ) {
//    SpUtils.init();
  }
}

class DriveBuilder extends StatefulWidget {
  final Widget child;

  DriveBuilder({this.child});

  @override
  _DriveBuilderState createState() => _DriveBuilderState();
}

class _DriveBuilderState extends State<DriveBuilder> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      MvcMaterialApp.context = context;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

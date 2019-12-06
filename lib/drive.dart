import 'dart:async';
import 'package:flutter/services.dart';
export 'src/base/page/page.dart';
export 'src/widget/fragment/view.dart';
export 'src/widget/image/cache/view.dart';
export 'src/widget/keyboard/view.dart';
export 'src/widget/refresh/view.dart';
export 'src/widget/tab/view.dart';
export 'src/widget/material_app.dart';
export 'src/widget/system_state_bar.dart';
export 'src/utils/db.dart';
export 'src/utils/http.dart';
export 'src/utils/image_picker.dart';
export 'src/utils/sp.dart';

class Drive {
  static const MethodChannel _channel =
      const MethodChannel('drive');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

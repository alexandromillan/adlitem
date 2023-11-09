import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';

class Devices {
  static final Devices _singleton = Devices._internal();
  factory Devices() {
    return _singleton;
  }
  Devices._internal();

  bool isPhone = false;
  bool isTablet = false;
  bool isOther = false;

  bool get isDesktop =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.windows;

  bool get isMobile =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;

  void DetectDeviceSize() {
    final double devicePixelRatio = ui.window.devicePixelRatio;

    final ui.Size size = ui.window.physicalSize;
    final double width = size.width;
    final double height = size.height;

    if (devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      isTablet = true;
      isPhone = false;
    } else if (devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      isTablet = true;
      isPhone = false;
    } else {
      isTablet = false;
      isPhone = true;
    }
  }
}

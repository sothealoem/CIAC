import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class UIConstants {
  static const int spacing = 16;
  static const int spacingSmall = 12;
  static const int spacingMedium = 18;
  static const int spacingHigh = 50;
  static const int midSpacing = spacing ~/ 2;
  static const int radius = 8;
  static const double btnHeight = 50;
  static const double designWidth = 375;
  static const double designHeight = 812;

  static BuildContext? get _context => Get.context;

  static Size get _screenSize {
    final context = _context;
    if (context != null) {
      return MediaQuery.sizeOf(context);
    }
    return const Size(designWidth, designHeight);
  }

  static double _scaleW([BuildContext? context]) {
    final size = context != null ? MediaQuery.sizeOf(context) : _screenSize;
    return size.width / designWidth;
  }

  static double _scaleH([BuildContext? context]) {
    final size = context != null ? MediaQuery.sizeOf(context) : _screenSize;
    return size.height / designHeight;
  }

  static double _safeScale([BuildContext? context]) {
    final value = (_scaleW(context) + _scaleH(context)) / 2;
    return value.clamp(0.85, 1.25);
  }

  // Dynamic width
  static double w(num value, {BuildContext? context}) {
    return value * _scaleW(context);
  }

  // Dynamic height
  static double h(num value, {BuildContext? context}) {
    return value * _scaleH(context);
  }

  // Dynamic font size
  static double sp(num value, {BuildContext? context}) {
    return value * _safeScale(context);
  }

  // Dynamic radius
  static double r(num value, {BuildContext? context}) {
    return value * _safeScale(context);
  }

  // Dynamic uniform spacing (scaled by width)
  static double gap(num value, {BuildContext? context}) {
    return w(value, context: context);
  }

  static EdgeInsets padAll(num value, {BuildContext? context}) {
    final v = gap(value, context: context);
    return EdgeInsets.all(v);
  }

  static EdgeInsets padH(num value, {BuildContext? context}) {
    final v = gap(value, context: context);
    return EdgeInsets.symmetric(horizontal: v);
  }

  static EdgeInsets padV(num value, {BuildContext? context}) {
    final v = gap(value, context: context);
    return EdgeInsets.symmetric(vertical: v);
  }
}

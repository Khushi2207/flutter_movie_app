import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension DisplayMethodsExtension on num {
  // 1 -> width, 2 -> height, 3 -> font, 4 -> radiusMultiplier
  double toPixelHeight(BuildContext context) {
    return calculatePixels(this, context, 1);
  }

  double toPixelWidth(BuildContext context) {
    return calculatePixels(this, context, 2);
  }

  double toPixelFont(BuildContext context) {
    return calculatePixels(this, context, 3);
  }

  double toPixelMultiplier(BuildContext context) {
    return calculatePixels(this, context, 4);
  }

  double calculatePixels(num value, BuildContext context, int type) {
    double height = MediaQuery.of(context).size.width / 393;
    double width = MediaQuery.of(context).size.height / 852;
    return type == 1 ? (value * (width / 393)) : type == 2 ? (value * (height / 852))
            : type == 3 ? (value * max(height, width)) : (value * min(height, width));
  }
}


class DisplayMethods {
  final BuildContext context;
  const DisplayMethods({required this.context});

  double getVariablePixelWidth() {
    double width = MediaQuery.of(context).size.width;
    double variablePixelWidth = width / 393;
    return variablePixelWidth;
  }

  double getVariablePixelHeight() {
    double height = MediaQuery.of(context).size.height;
    double getVariablePixelHeight = height / 852;
    return getVariablePixelHeight;
  }

  double getTextFontMultiplier() {
    double variablePixelWidth = MediaQuery.of(context).size.width / 393;
    double variablePixelHeight = MediaQuery.of(context).size.height / 852;
    double multiplier = max(variablePixelHeight, variablePixelWidth);
    return multiplier;
  }

  double getPixelMultiplier() {
    double variablePixelWidth = MediaQuery.of(context).size.width / 393;
    double variablePixelHeight = MediaQuery.of(context).size.height / 852;
    double multiplier = min(variablePixelHeight, variablePixelWidth);
    return multiplier;
  }

  void portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}

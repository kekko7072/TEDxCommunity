import 'package:flutter/cupertino.dart';

import 'imports.dart';

class Style {
  static int kResizeWidthValue = 700;

  ///Colors
  static Color primaryColor = CupertinoColors.activeBlue;

  static Color barLightColor = const Color(0xFFF2F2F7);
  static Color barDarkColor = const Color(0xFF2C2C2E);

  static Color backgroundLightColor = const Color(0xFFFFFFFF);
  static Color backgroundDarkColor = const Color(0xFF1C1C1E);

  static Color whiteColor = Colors.white;
  static Color blackColor = Colors.black;

  static Color inputTextFieldLightColor = const Color(0xFFF0F0F0);
  static Color inputTextFieldDarkColor = const Color(0xBF141414);

  static Color menuColor(BuildContext context) => CupertinoDynamicColor.resolve(
      CupertinoDynamicColor.withBrightness(
        color: barLightColor,
        darkColor: barDarkColor,
      ),
      context);

  static Color textMenuColor(BuildContext context) =>
      CupertinoDynamicColor.resolve(
          CupertinoDynamicColor.withBrightness(
            color: barDarkColor,
            darkColor: barLightColor,
          ),
          context);

  static Color backgroundColor(BuildContext context) =>
      CupertinoDynamicColor.resolve(
          CupertinoDynamicColor.withBrightness(
            color: backgroundLightColor,
            darkColor: backgroundDarkColor,
          ),
          context);

  static Color textColor(BuildContext context) => CupertinoDynamicColor.resolve(
      CupertinoDynamicColor.withBrightness(
        color: blackColor,
        darkColor: whiteColor,
      ),
      context);

  static Color inputTextFieldColor(BuildContext context) =>
      CupertinoDynamicColor.resolve(
          CupertinoDynamicColor.withBrightness(
            color: Style.inputTextFieldLightColor,
            darkColor: Style.inputTextFieldDarkColor,
          ),
          context);

  ///Radius
  static double inputTextFieldRadius = 10.00;
}

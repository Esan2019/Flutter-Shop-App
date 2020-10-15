import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData mediaQuery;
  static double screenHeight, screenWidth;
  static Orientation orientation;
  static double textScaleFactor;

  static bool get isInLandscape => orientation == Orientation.landscape;

  static bool get isInPortrait => orientation == Orientation.portrait;

  static double getHeightPercentage(double percentage) =>
      screenHeight * (percentage / 100);

  static double getWidthPercentage(double percentage) =>
      screenWidth * (percentage / 100);

  static void init(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    screenHeight = mediaQuery.size.height;
    screenWidth = mediaQuery.size.width;
    orientation = mediaQuery.orientation;
    textScaleFactor = mediaQuery.textScaleFactor;
  }

  static SizedBox getSpacing({double vertical = 0, double horizontal = 0}) {
    return SizedBox(
      height: getHeightPercentage(vertical),
      width: getWidthPercentage(horizontal),
    );
  }
}

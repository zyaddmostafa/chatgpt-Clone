import 'package:flutter/cupertino.dart';

extension ScreenSize on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenTopPadding => MediaQuery.of(this).padding.top;
  double get screenBottomPadding => MediaQuery.of(this).padding.bottom;
  double get screenLeftPadding => MediaQuery.of(this).padding.left;
  double get screenRightPadding => MediaQuery.of(this).padding.right;

  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
}

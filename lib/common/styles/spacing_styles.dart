import '/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';

class ESpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: ESizes.appBarHeight,
    bottom: ESizes.defaultSpace,
    left: ESizes.defaultSpace,
    right: ESizes.defaultSpace,
  );
}

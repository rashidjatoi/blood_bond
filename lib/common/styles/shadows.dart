import '/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';

class EShadows {
  static final verticalProductShadows = BoxShadow(
    color: EColors.darkGrey.withOpacity(.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );

  static final horizontalProductShadows = BoxShadow(
    color: EColors.darkGrey.withOpacity(.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );
}

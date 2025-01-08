import '/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class ECircularIcon extends StatelessWidget {
  const ECircularIcon({
    super.key,
    required this.icon,
    this.width,
    this.height,
    this.size = ESizes.lg,
    this.color,
    this.backgroundColor,
    this.onPressed,
  });

  final IconData icon;
  final double? width, height, size;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: backgroundColor != null
            ? backgroundColor!
            : dark
                ? EColors.black.withOpacity(.9)
                : EColors.white.withOpacity(.9),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon,
            color: color ?? (dark ? EColors.white : EColors.black), size: size),
      ),
    );
  }
}

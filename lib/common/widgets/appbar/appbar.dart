import '/utils/constants/sizes.dart';
import '/utils/device/device_utility.dart';
import '/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';

class EAppBar extends StatelessWidget implements PreferredSize {
  const EAppBar({
    super.key,
    this.title,
    this.showBackArrow = false,
    this.leadingIcon,
    this.action,
    this.leadingOnPressed,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? action;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: ESizes.defaultSpace / 2,
        right: ESizes.defaultSpace,
      ),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Iconsax.arrow_left,
                  color: EHelperFunctions.isDarkMode(context)
                      ? EColors.light
                      : EColors.dark,
                ))
            : leadingIcon != null
                ? IconButton(
                    onPressed: leadingOnPressed, icon: Icon(leadingIcon))
                : null,
        actions: action,
        title: title,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(EDeviceUtils.getAppBarHeight());

  @override
  Widget get child => throw UnimplementedError();
}

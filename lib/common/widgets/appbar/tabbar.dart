import '/utils/constants/colors.dart';
import '/utils/device/device_utility.dart';
import '/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ETabBar extends StatelessWidget implements PreferredSize {
  const ETabBar({
    super.key,
    required this.tabs,
  });

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Material(
      color:
          EHelperFunctions.isDarkMode(context) ? EColors.dark : EColors.light,
      child: TabBar(
        tabAlignment: TabAlignment.start,
        tabs: tabs,
        isScrollable: true,
        indicatorColor: EColors.primary,
        labelColor: dark ? EColors.white : EColors.primary,
        unselectedLabelColor: EColors.darkGrey,
      ),
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(EDeviceUtils.getAppBarHeight());
}

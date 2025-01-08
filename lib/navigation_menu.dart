import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/features/personalization/screens/settings/settings.dart';
import '/utils/constants/colors.dart';
import 'features/chat_system/chat_room.dart';
import 'features/home/home_screen.dart';
import 'features/search_user/search_user_screen.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStatePropertyAll(
            const TextStyle(color: EColors.white),
          ),
        ),
        child: Obx(
          () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            backgroundColor: Colors.red,
            indicatorColor: EColors.white,
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Iconsax.home,
                  color: EColors.white,
                ),
                selectedIcon: Icon(
                  Iconsax.home,
                  color: EColors.black,
                ),
                label: "Home",
              ),
              NavigationDestination(
                icon: Icon(
                  Iconsax.search_favorite,
                  color: EColors.white,
                ),
                selectedIcon: Icon(
                  Iconsax.search_favorite,
                  color: EColors.black,
                ),
                label: "Search",
              ),
              NavigationDestination(
                icon: Icon(
                  Iconsax.direct_right,
                  color: EColors.white,
                ),
                selectedIcon: Icon(
                  Iconsax.direct_right,
                  color: EColors.black,
                ),
                label: "Messages",
              ),
              NavigationDestination(
                icon: Icon(
                  Iconsax.user,
                  color: EColors.white,
                ),
                selectedIcon: Icon(
                  Iconsax.home,
                  color: EColors.black,
                ),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
      body: Obx(
        () => controller.screens[controller.selectedIndex.value],
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const UserSearchScreen(),
    const ChatRoomUserAndDonor(),
    const SettingScreen(),
  ];
}

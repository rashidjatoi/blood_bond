import '/common/widgets/list_tiles/settings_menu_tile.dart';
import '/common/widgets/texts/section_heading.dart';
import '/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import '../../../../isavalable_widget.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../about_screen.dart';
import '../../../home/myblood_request.dart';
import '../../../home/request_accepted_by_me.dart';
import '../../../search_user/search_user_screen.dart';
import '../../controllers/user_controller.dart';
import '../profile/profile_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final controller = UserController.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchUserRecord();
      controller.onInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          actions: [
            IconButton(
              icon: const Icon(
                Iconsax.edit,
                color: Colors.white,
              ),
              onPressed: () => Get.to(
                () => const ProfileScreen(),
              ),
            )
          ],
        ),
        body: Obx(
          () => controller.profileLoading.value == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      //SIZEDBOX
                      const SizedBox(height: ESizes.spaceBtwItems),

                      /// User Profile Card
                      const EUserProfileTile(),

                      // Blood donation switch
                      controller.user.value.userType == 'donor'
                          ? const BloodDonationSwitch()
                          : Container(),

                      ///  -- Body
                      Padding(
                        padding: const EdgeInsets.all(ESizes.defaultSpace),
                        child: Column(
                          children: [
                            /// -- Account Settings
                            const ESectionHeading(
                              title: 'Account Settings',
                              showActionButton: false,
                            ),

                            //SIZEDBOX
                            const SizedBox(height: ESizes.spaceBtwItems),

                            // Search profile nearyby
                            SettingsMenuTile(
                              icon: Iconsax.user,
                              title: 'Search Users',
                              subTitle: 'Search Profile Near By',
                              onTap: () {
                                Get.to(() => const UserSearchScreen());
                              },
                            ),

                            // Blood donation switch
                            controller.user.value.userType == 'donor'
                                ? SettingsMenuTile(
                                    icon: Iconsax.notification,
                                    title: 'Blood Requests',
                                    subTitle:
                                        'Click to see your blood requests',
                                    onTap: () {
                                      Get.to(() =>
                                          const RequestAcceptedByMeScreen());
                                    },
                                  )
                                :
                                // ABOUT
                                SettingsMenuTile(
                                    icon: Iconsax.notification,
                                    title: 'Blood Requests',
                                    subTitle:
                                        'Click to see your blood requests',
                                    onTap: () {
                                      Get.to(
                                          () => const MyBloodRequestScreen());
                                    },
                                  ),

                            // ABOUT
                            SettingsMenuTile(
                              icon: Iconsax.info_circle,
                              title: 'About',
                              subTitle: 'Click this to see the information',
                              onTap: () {
                                Get.to(() => const AboutScreen());
                              },
                            ),

                            SettingsMenuTile(
                              icon: Iconsax.logout,
                              title: 'Sign Out',
                              subTitle:
                                  'Click logout to sign out of your account',
                              onTap: () async {
                                // Show the confirmation dialog
                                bool? shouldLogout = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Log Out'),
                                      content: const Text(
                                          'Do you want to log out of your account?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            // Close the dialog and return false
                                            Navigator.of(context).pop(false);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Close the dialog and return true
                                            Navigator.of(context).pop(true);
                                          },
                                          child: const Text(
                                            'Log Out',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                // If the user confirmed logout, perform the logout operation
                                if (shouldLogout ?? false) {
                                  await AuthenticationRepository.instance
                                      .logout();
                                }
                              },
                            ),

                            //SIZEDBOX
                            const SizedBox(
                              height: ESizes.spaceBtwSections * 2.5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ));
  }
}

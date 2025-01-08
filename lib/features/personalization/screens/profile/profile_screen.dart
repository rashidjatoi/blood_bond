import '/common/widgets/images/e_circular_image.dart';
import '/common/widgets/shimmer_effect/shimmer.dart';
import '/common/widgets/texts/section_heading.dart';
import '/features/personalization/controllers/user_controller.dart';
import '/features/personalization/screens/profile/widgets/change_name.dart';
import '/features/personalization/screens/profile/widgets/profile_menu.dart';
import '/utils/constants/image_strings.dart';
import '/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/change_address.dart';
import 'widgets/change_phone.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = UserController.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchUserRecord();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Information',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),

      /// -- Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              /// Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.user.value.profilePicture;
                      final image =
                          networkImage.isEmpty ? EImages.user : networkImage;
                      return controller.imageUploading.value
                          ? const EShimmerEffect(
                              width: 100,
                              height: 100,
                              radius: 80,
                            )
                          : ECircularImage(
                              isNetworkImage:
                                  networkImage.isNotEmpty ? true : false,
                              image: image,
                              width: 100,
                              height: 100,
                            );
                    }),
                    TextButton(
                      onPressed: () => controller.uploadUserProfilePicture(),
                      child: const Text('Change Profile Picture'),
                    )
                  ],
                ),
              ),

              /// -- Details
              const SizedBox(height: ESizes.spaceBtwItems / 2),

              const ESectionHeading(
                title: 'Personal Information',
                showActionButton: false,
              ),

              EProfileMenu(
                title: 'Name',
                value: controller.user.value.fullName,
                onPressed: () => Get.off(() => const ChangeName()),
              ),
              EProfileMenu(
                title: 'Username',
                value: controller.user.value.userName,
                onPressed: () {},
              ),

              EProfileMenu(
                title: 'Email',
                value: controller.user.value.email,
                onPressed: () {},
              ),
              EProfileMenu(
                title: 'Phone No',
                value: controller.user.value.phoneNumber,
                onPressed: () {
                  Get.to(() => const ChangePhone());
                },
              ),

              EProfileMenu(
                title: 'City',
                value: controller.user.value.city,
                onPressed: () {
                  Get.to(() => const ChangeAddress());
                },
              ),

              const SizedBox(height: ESizes.spaceBtwItems),

              // Delete Account
              InkWell(
                onTap: () {
                  controller.deleteAccountWarningPopup();
                },
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

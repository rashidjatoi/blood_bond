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

class BloodDonorProfileScreen extends StatefulWidget {
  final String userId;
  const BloodDonorProfileScreen({super.key, required this.userId});

  @override
  State<BloodDonorProfileScreen> createState() =>
      _BloodDonorProfileScreenState();
}

class _BloodDonorProfileScreenState extends State<BloodDonorProfileScreen> {
  final controller = UserController.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchPerticularUserRecord(widget.userId);
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
          child: Obx(
            () {
              if (controller.profileParticularLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    /// Profile Picture
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Obx(() {
                            final networkImage =
                                controller.userPerticular.value.profilePicture;
                            final image = networkImage.isEmpty
                                ? EImages.user
                                : networkImage;
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
                      value: controller.userPerticular.value.fullName,
                      onPressed: () => Get.off(() => const ChangeName()),
                    ),
                    EProfileMenu(
                      title: 'Username',
                      value: controller.userPerticular.value.userName,
                      onPressed: () {},
                    ),

                    EProfileMenu(
                      title: 'Email',
                      value: controller.userPerticular.value.email,
                      onPressed: () {},
                    ),
                    EProfileMenu(
                      title: 'Phone No',
                      value: controller.userPerticular.value.phoneNumber,
                      onPressed: () {},
                    ),

                    EProfileMenu(
                      title: 'City',
                      value: controller.userPerticular.value.city,
                      onPressed: () {},
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

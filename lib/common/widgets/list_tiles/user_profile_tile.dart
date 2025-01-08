import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/personalization/controllers/user_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../images/e_circular_image.dart';

class EUserProfileTile extends StatelessWidget {
  const EUserProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return ListTile(
      leading: Obx(() {
        final networkImage = controller.user.value.profilePicture;
        final image = networkImage.isEmpty ? EImages.user : networkImage;
        return ECircularImage(
          isNetworkImage: networkImage.isNotEmpty ? true : false,
          image: image,
          padding: 0,
          width: 50,
          height: 50,
        );
      }),
      title: Text(
        controller.user.value.fullName,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .apply(color: EColors.black),
      ),
      subtitle: Text(
        controller.user.value.email,
        style:
            Theme.of(context).textTheme.bodyMedium!.apply(color: EColors.black),
      ),
    );
  }
}

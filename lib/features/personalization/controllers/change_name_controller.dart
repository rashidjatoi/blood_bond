import '/data/repositories/user/user_repository.dart';
import '/features/personalization/controllers/user_controller.dart';
import '/features/personalization/screens/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/services/network_manager.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

class ChangeNameController extends GetxController {
  static ChangeNameController get instance => Get.find();

  /// Variables
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> changeNameFormKey = GlobalKey<FormState>();

  /// Init user data when home screen appears
  @override
  void onInit() {
    initializeName();
    super.onInit();
  }

  /// Fetch user record
  Future<void> initializeName() async {
    firstName.text = userController.user.value.firstName;
    lastName.text = userController.user.value.lastName;
  }

  Future<void> changeUserName() async {
    try {
      // Start Loading
      EFullScreenLoader.onLoadingDialog(
        'We are updating your information...',
        EImages.docerAnimation,
      );

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!changeNameFormKey.currentState!.validate()) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // Update user first name and last name in the Firebase Firestore
      Map<String, dynamic> name = {
        'FirstName': firstName.text.trim(),
        'LastName': lastName.text.trim()
      };
      await userRepository.updateSingleField(name);

      // Update the Rx user value
      userController.user.value.firstName = firstName.text.trim();
      userController.user.value.lastName = lastName.text.trim();

      // Stop Loading
      EFullScreenLoader.stopLoading();

      // Show Success Message
      ELoaders.successSnackBar(
        title: 'Congratulations',
        message: 'Your name has been updated.',
      );

      // Move to previous screen
      Get.off(() => const ProfileScreen());
    } catch (e) {
      // Stop Loading
      EFullScreenLoader.stopLoading();

      // Show Failed Message
      ELoaders.errorSnackBar(
        title: 'Oh snap',
        message: e.toString(),
      );
    }
  }
}

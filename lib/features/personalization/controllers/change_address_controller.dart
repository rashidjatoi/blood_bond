import '/data/repositories/user/user_repository.dart';
import '/features/personalization/controllers/user_controller.dart';
import '/navigation_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/services/network_manager.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

class ChangeAddressController extends GetxController {
  static ChangeAddressController get instance => Get.find();

  /// Variables
  final address = TextEditingController();
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
    address.text = userController.user.value.city;
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
      Map<String, dynamic> name = {'city': address.text.trim()};
      await userRepository.updateSingleField(name);

      // Update the Rx user value
      userController.user.value.lastName = address.text.trim();

      // Stop Loading
      EFullScreenLoader.stopLoading();

      // Show Success Message
      ELoaders.successSnackBar(
        title: 'Congratulations',
        message: 'Your City has been updated.',
      );

      // Move to previous screen
      Get.offAll(() => const NavigationMenu());
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

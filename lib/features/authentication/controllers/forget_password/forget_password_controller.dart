import '/data/repositories/authentication/authentication_repository.dart';
import '/utils/constants/image_strings.dart';
import '/utils/popups/full_screen_loader.dart';
import '/utils/popups/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../data/services/network_manager.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  /// Send Password Reset Email
  sendPasswordResetEmail() async {
    try {
      // Start Loader
      EFullScreenLoader.onLoadingDialog(
        'Precessing your request...',
        EImages.docerAnimation,
      );

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // Send email to reset password
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      // Remove loader
      EFullScreenLoader.stopLoading();

      // Show success screen
      ELoaders.successSnackBar(
        title: 'Email Sent',
        message: 'Email link sent to reset your password'.tr,
      );
    } catch (e) {
      // Remove Loader
      EFullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      ELoaders.errorSnackBar(
        title: 'Oh snap',
        message: e.toString(),
      );
    }
  }

  reSendPasswordResetEmail(String email) async {
    try {
      // Start Loader
      EFullScreenLoader.onLoadingDialog(
        'Precessing your request...',
        EImages.docerAnimation,
      );

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // Send email to reset password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      // Remove loader
      EFullScreenLoader.stopLoading();

      // Show success screen
      ELoaders.successSnackBar(
        title: 'Email Sent',
        message: 'Email link sent to reset your password'.tr,
      );
    } catch (e) {
      // Remove Loader
      EFullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      ELoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
    }
  }
}

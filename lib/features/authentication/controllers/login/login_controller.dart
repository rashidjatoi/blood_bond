import '/data/repositories/authentication/authentication_repository.dart';
import '/features/personalization/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../data/services/network_manager.dart';
import '../../../../utils/popups/loaders.dart';

class LoginController extends GetxController {
  /// Variables
  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  final userController = Get.put(UserController());

  /// -- Email and Password SignIn
  Future<void> emailAndPasswordSignIn() async {
    try {
      //   Start Loading
      isLoading.value = true;

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      // Login user using Email and Password Authentication
      await AuthenticationRepository.instance.login(
        email.text.trim(),
        password.text.trim(),
      );

      // Remove Loader
      isLoading.value = false;

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      // Remove Loader
      isLoading.value = false;

      // Show some Generic Error to the user
      ELoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
    }
  }
}

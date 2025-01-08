import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../navigation_menu.dart';
import '../../authentication/screens/login/login.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get instance => Get.find();

  /// Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  /// Function to show relevant screen
  screenRedirect() {
    log("Inside Splash Screen");
    final user = _auth.currentUser;

    Future.delayed(const Duration(seconds: 3), () {
      if (user != null) {
        Get.offAll(() => const NavigationMenu());
      } else {
        Get.offAll(() => const LoginScreen());
      }
    });
  }

  @override
  void onInit() {
    screenRedirect();
    super.onInit();
  }
}

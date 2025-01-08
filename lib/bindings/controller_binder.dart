import 'package:get/get.dart';

import '/data/repositories/authentication/authentication_repository.dart';
import '/data/services/network_manager.dart';
import '/features/authentication/controllers/onboarding/onboarding_controller.dart';
import '/features/authentication/controllers/signup/signup_controller.dart';
import '../features/home/controller/home_controller.dart';
import '../features/personalization/controllers/change_address_controller.dart';
import '../features/personalization/controllers/user_controller.dart';
import '../features/splash/controller/splash_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashScreenController());
    Get.put(AuthenticationRepository());
    Get.put(NetworkManager());
    Get.put(OnBoardingController());
    Get.put(HomeController());
    Get.put(SignupController());
    Get.put(UserController());
    Get.put(ChangeAddressController());
  }
}

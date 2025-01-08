import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '/data/repositories/authentication/authentication_repository.dart';
import '/data/repositories/user/user_repository.dart';
import '/features/authentication/models/user_model.dart';
import '/utils/popups/loaders.dart';
import '../../../../data/services/network_manager.dart';
import '../../../../navigation_menu.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final isLoading = false.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final firstName = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();
  final bloodGroup = TextEditingController();

  final userType = ''.obs;
  final selectedCity = ''.obs;

  final lastDonationDate = TextEditingController();
  final bloodDisability = TextEditingController();

  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  @override
  void onClose() {
    super.onClose();
    firstName.dispose();
    lastName.dispose();
    userName.dispose();
    email.dispose();
    phoneNumber.dispose();
    password.dispose();
    bloodGroup.dispose();
    lastDonationDate.dispose();
    bloodDisability.dispose();
  }

  /// Signup
  void signup() async {
    try {
      // Start Loading
      isLoading.value = true;

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        return;
      }

      // Form Validation
      if (!signupFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      // Register user in the Firebase Authentication and Save user data in the Firebase
      final userCredential =
          await AuthenticationRepository.instance.registerWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      // Save Authenticated user data in the Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        userName: userName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
        bloodType: bloodGroup.text.trim(),
        deviceToken: '',
        isAvailable: 'true',
        userType: userType.value,
        lastDonationDate: lastDonationDate.text,
        bloodDisability: bloodDisability.text,
        city: selectedCity.value,
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // Stop Loading
      isLoading.value = false;
      // Show Success Message
      ELoaders.successSnackBar(
        title: 'Congratulations',
        message: 'Your account has been crated!',
      );

      // Move to verify email screen
      Get.offAll(() => const NavigationMenu());
    } catch (e) {
      //   Remove Loader
      isLoading.value = false;
      // Show some Generic Error to the user
      ELoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
    }
  }
}

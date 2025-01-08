import '/data/repositories/authentication/authentication_repository.dart';
import '/data/repositories/user/user_repository.dart';
import '/features/authentication/models/user_model.dart';
import '/features/authentication/screens/login/login.dart';
import '/features/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import '/utils/constants/sizes.dart';
import '/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/services/network_manager.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../authentication/models/user_perticular_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  final profileParticularLoading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final hidePassword = false.obs;
  final imageUploading = false.obs;
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();
  Rx<UserModel> user = UserModel.empty().obs;
  Rx<UserPerticularModel> userPerticular = UserPerticularModel.empty().obs;
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  /// Fetch user record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
      profileLoading.value = false;
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  /// Fetch user record
  Future<void> fetchPerticularUserRecord(String userId) async {
    try {
      profileParticularLoading.value = true;
      final userPerticular =
          await userRepository.fetchPerticulatUserDetails(userId);
      this.userPerticular(userPerticular);
    } catch (e) {
      userPerticular(UserPerticularModel.empty());
    } finally {
      profileParticularLoading.value = false;
    }
  }

  /// Save user Record from any Registration provider
  Future<void> saveUserRecord(UserCredential? userCredential) async {
    try {
      // First update Rx User and then and then check if user data is already stored. If not stored new data
      await fetchUserRecord();

      if (userCredential != null) {
        // Convert Name of First Name and Last Name
        final nameParts =
            UserModel.nameParts(userCredential.user!.displayName ?? '');
        final userName =
            UserModel.generateUsername(userCredential.user!.displayName ?? '');

        // Map Data
        final user = UserModel(
          id: userCredential.user!.uid,
          firstName: nameParts[0],
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          userName: userName,
          email: userCredential.user!.email ?? '',
          phoneNumber: userCredential.user!.phoneNumber ?? '',
          profilePicture: userCredential.user!.photoURL ?? '',
          bloodType: '',
          isAvailable: '',
        );

        // Save user data
        await userRepository.saveUserRecord(user);
      }
    } catch (e) {
      ELoaders.warningSnackBar(
        title: 'Data not saved',
        message:
            'Something went wrong while saving your information. You can re-save your data in your profile',
      );
    }
  }

  /// Delete Account Warning
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(ESizes.md),
      title: "Delete Account",
      middleText:
          "Are you sure you want to delete your account permanently? This action is not reversible and all your data will be removed.",
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: ESizes.lg),
          child: Text("Delete"),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Text("Cancel"),
      ),
    );
  }

  /// Delete User Account
  void deleteUserAccount() async {
    try {
      // Start Loading
      EFullScreenLoader.onLoadingDialog('Processing', EImages.docerAnimation);

      // First Re-Authenticate User
      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;

      if (provider.isNotEmpty) {
        // Re Verify Auth Email
        if (provider == "google.com") {
          await auth.deleteAccount();
          EFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == "password") {
          EFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      //   Remove Loader
      EFullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      ELoaders.errorSnackBar(title: 'Oh snap', message: e.toString());
    }
  }

  /// -- Re-Authenticate Before Deleting
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      // Start Loading
      EFullScreenLoader.onLoadingDialog('Processing', EImages.docerAnimation);

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        EFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!reAuthFormKey.currentState!.validate()) {
        EFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
        verifyEmail.text.trim(),
        verifyPassword.text.trim(),
      );
      await AuthenticationRepository.instance.deleteAccount();
      EFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      EFullScreenLoader.stopLoading();
      ELoaders.warningSnackBar(title: 'Oh snap', message: e.toString());
    }
  }

  /// Upload User profile picture
  Future<void> uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 512,
        maxHeight: 512,
      );
      if (image != null) {
        imageUploading.value = true;
        // Upload Image
        final imageUrl =
            await userRepository.uploadImage("User/Images/Profile/", image);

        // Update User Image Record
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();

        ELoaders.successSnackBar(
            title: 'Congratulations', message: 'Your Profile has been update');
      }
    } catch (e) {
      ELoaders.errorSnackBar(
          title: 'Oh snap', message: 'Some thing went wrong: $e');
    } finally {
      imageUploading.value = false;
    }
  }
}

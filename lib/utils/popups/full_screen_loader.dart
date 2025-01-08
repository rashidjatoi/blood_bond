import '/utils/constants/colors.dart';
import '/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/animation_loader.dart';

/// A utility class for maintaining full-screen loading dialog
class EFullScreenLoader {
  /// Open full screen loading dialog with a given text and animation
  /// This method doesn't return anything
  ///
  /// Parameters:
  /// - text: The text to be displayed in the loading dialog
  /// - animation: The Lottie animation to be shown
  static void onLoadingDialog(String text, String animation) {
    showDialog(
      context:
          Get.overlayContext!, // Use Get.overlayContext for overlay dialogs
      barrierDismissible:
          true, // The dialog can't be dismissible by tapping outside it
      builder: (_) => PopScope(
        canPop: false, // Disable popping with back button
        child: Container(
          color: EHelperFunctions.isDarkMode(Get.context!)
              ? EColors.dark
              : EColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 250), // Adjust the spacing as needed
              EAnimationLoader(text: text, animation: animation),
            ],
          ),
        ),
      ),
    );
  }

  /// Stop the currently open loading dialog
  /// This method doesn't return anything
  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop(); // Close the dialog using Navigator
  }
}

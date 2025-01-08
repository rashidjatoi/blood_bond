import '/features/authentication/controllers/forget_password/forget_password_controller.dart';
import '/features/authentication/screens/login/login.dart';
import '/utils/constants/sizes.dart';
import '/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final controller = ForgetPasswordController.instance;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              /// Image with 60% screen width
              Image(
                image: const AssetImage(EImages.deliveredEmailIllustration),
                width: EHelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              /// Email, Title and subtitle
              Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              Text(
                ETexts.changeYourPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ESizes.spaceBtwItems),

              Text(
                ETexts.changeYourPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              /// Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  child: const Text(ETexts.done),
                  onPressed: () => Get.offAll(() => const LoginScreen()),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwItems),

              /// Resend email
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  child: const Text(ETexts.resendEmail),
                  onPressed: () => controller.reSendPasswordResetEmail(email),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

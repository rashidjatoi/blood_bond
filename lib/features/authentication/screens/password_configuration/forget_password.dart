import '/features/authentication/controllers/forget_password/forget_password_controller.dart';
import '/utils/constants/sizes.dart';
import '/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/text_strings.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ETexts.forgetPasswordTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            children: [
              /// Heading

              const SizedBox(height: ESizes.spaceBtwItems),
              Text(
                ETexts.forgetPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: ESizes.spaceBtwSections * 2),

              /// Email field
              Form(
                key: controller.forgetPasswordFormKey,
                child: TextFormField(
                  controller: controller.email,
                  validator: EValidator.validateEmail,
                  decoration: const InputDecoration(
                    label: Text(ETexts.email),
                    prefixIcon: Icon(Iconsax.direct_right),
                  ),
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              /// Submit Button
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
                  onPressed: () => controller.sendPasswordResetEmail(),
                  child: const Text(ETexts.submit),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

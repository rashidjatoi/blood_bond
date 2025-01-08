import '/features/authentication/controllers/login/login_controller.dart';
import '/features/authentication/screens/password_configuration/forget_password.dart';
import '/features/authentication/screens/signup/signup.dart';
import '/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class ELoginForm extends StatelessWidget {
  const ELoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: ESizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: controller.email,
              validator: (value) => EValidator.validateEmail(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                label: Text(ETexts.email),
              ),
            ),

            const SizedBox(height: ESizes.spaceBtwInputFields),

            /// Password
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: (value) =>
                    EValidator.validateEmptyText('Password', value),
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.lock),
                  label: const Text(ETexts.password),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye),
                  ),
                ),
              ),
            ),

            const SizedBox(height: ESizes.spaceBtwInputFields / 2),

            /// Remember me and forget password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /// Forget Password
                TextButton(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  child: const Text(ETexts.forgetPassword),
                )
              ],
            ),

            const SizedBox(height: ESizes.spaceBtwSections / 2),

            /// SignIn Button
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  onPressed: () => controller.emailAndPasswordSignIn(),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(ETexts.signIn),
                ),
              ),
            ),

            const SizedBox(height: ESizes.spaceBtwItems),

            /// Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all<BorderSide>(
                    const BorderSide(color: Colors.red, width: 1),
                  ),
                ),
                onPressed: () => Get.to(() => const SignupScreen()),
                child: const Text(ETexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

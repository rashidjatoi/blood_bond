import '/common/widgets/appbar/appbar.dart';
import '/features/personalization/controllers/user_controller.dart';
import '/utils/constants/sizes.dart';
import '/utils/constants/text_strings.dart';
import '/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      appBar: const EAppBar(
        title: Text("Re-Authenticate User"),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Form(
            key: controller.reAuthFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Email
                TextFormField(
                  controller: controller.verifyEmail,
                  validator: EValidator.validateEmail,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    label: Text(ETexts.email),
                  ),
                ),
                const SizedBox(height: ESizes.spaceBtwInputFields),

                /// Password
                Obx(
                  () => TextFormField(
                    controller: controller.verifyPassword,
                    validator: (value) =>
                        EValidator.validateEmptyText(ETexts.password, value),
                    textInputAction: TextInputAction.next,
                    obscureText: controller.hidePassword.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.password_check),
                      label: const Text(ETexts.password),
                      suffixIcon: IconButton(
                        onPressed: () => controller.hidePassword.value =
                            !controller.hidePassword.value,
                        icon: Icon(
                          controller.hidePassword.value
                              ? Iconsax.eye
                              : Iconsax.eye_slash,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: ESizes.spaceBtwSections),

                /// Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        controller.reAuthenticateEmailAndPasswordUser(),
                    child: const Text("Verify"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

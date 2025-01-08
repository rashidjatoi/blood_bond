import '/features/personalization/controllers/change_name_controller.dart';
import '/utils/constants/sizes.dart';
import '/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/text_strings.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangeNameController());

    return Scaffold(
      /// Custom Appbar

      appBar: AppBar(
        title: const Text(
          'Change Name',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: Column(
          children: [
            /// Heading
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Kindly type your real name',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: ESizes.spaceBtwInputFields),

            /// Text Fields and buttons
            Form(
              key: controller.changeNameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.firstName,
                    validator: (value) =>
                        EValidator.validateEmptyText(ETexts.firstName, value),
                    expands: false,
                    decoration: const InputDecoration(
                      labelText: ETexts.firstName,
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                  const SizedBox(height: ESizes.spaceBtwInputFields),
                  TextFormField(
                    controller: controller.lastName,
                    validator: (value) =>
                        EValidator.validateEmptyText(ETexts.lastName, value),
                    expands: false,
                    decoration: const InputDecoration(
                      labelText: ETexts.lastName,
                      prefixIcon: Icon(Iconsax.user),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: ESizes.spaceBtwSections),

            /// Saved Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red),
                  side: MaterialStatePropertyAll(
                    BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                ),
                onPressed: () => controller.changeUserName(),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

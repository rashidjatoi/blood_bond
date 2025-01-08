import '/utils/constants/sizes.dart';
import '/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/change_address_controller.dart';

class ChangeAddress extends StatelessWidget {
  const ChangeAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangeAddressController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change City',
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
                'Kindly type your real City',
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
                    controller: controller.address,
                    validator: (value) =>
                        EValidator.validateEmptyText(ETexts.address, value),
                    expands: false,
                    decoration: const InputDecoration(
                      labelText: ETexts.address,
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

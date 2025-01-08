import '/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/signup/signup_controller.dart';

class ESignupForm extends StatelessWidget {
  const ESignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;

    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          /// First and Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) =>
                      EValidator.validateEmptyText('First name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    label: Text(ETexts.firstName),
                  ),
                ),
              ),
              const SizedBox(width: ESizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) =>
                      EValidator.validateEmptyText('Last name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    label: Text(ETexts.lastName),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields),

          /// Username
          TextFormField(
            controller: controller.userName,
            validator: (value) =>
                EValidator.validateEmptyText('Username', value),
            expands: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.user_edit),
              label: Text(ETexts.username),
            ),
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields),

          /// Email
          TextFormField(
            controller: controller.email,
            validator: (value) => EValidator.validateEmail(value),
            expands: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.direct),
              label: Text(ETexts.email),
            ),
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields),

          /// Phone Number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => EValidator.validatePhoneNumber(value),
            expands: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.call),
              label: Text(ETexts.phoneNo),
            ),
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields),

          DropdownButtonFormField<String>(
            value: controller.bloodGroup.text.isEmpty
                ? null
                : controller.bloodGroup.text,
            onChanged: (newValue) {
              controller.bloodGroup.text = newValue!;
            },
            items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                .map((String bloodType) {
              return DropdownMenuItem<String>(
                value: bloodType,
                child: Text(bloodType),
              );
            }).toList(),
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.category),
              labelText: "Blood Type",
            ),
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields),

          /// Password
          Obx(() => TextFormField(
                controller: controller.password,
                validator: (value) => EValidator.validatePassword(value),
                // expands: false,
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye),
                  ),
                  label: const Text(ETexts.password),
                ),
              )),
          const SizedBox(height: ESizes.spaceBtwInputFields),
          const Align(
              alignment: Alignment.centerLeft,
              child: Text("Are you a Donar or Patient")),

          /// Blood Donor / Patient Selection
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text("Donor"),
                    leading: Radio(
                      value: 'donor',
                      groupValue: controller.userType.value,
                      onChanged: (value) {
                        controller.userType.value = value!;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text("Patient"),
                    leading: Radio(
                      value: 'patient',
                      groupValue: controller.userType.value,
                      onChanged: (value) {
                        controller.userType.value = value!;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Last Donation Date (for Blood Donor)
          Obx(() {
            if (controller.userType.value == 'donor') {
              return TextFormField(
                controller: controller.lastDonationDate,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                  labelText: "Last Donation Date",
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    controller.lastDonationDate.text =
                        pickedDate.toLocal().toString().split(' ')[0];
                  }
                },
              );
            }
            return const SizedBox.shrink();
          }),

          /// Blood Disability (for Patient)
          Obx(() {
            if (controller.userType.value == 'patient') {
              return TextFormField(
                controller: controller.bloodDisability,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.info),
                  labelText: "Blood Disability",
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          const SizedBox(height: ESizes.spaceBtwInputFields),

          /// City Dropdown
          DropdownButtonFormField<String>(
            value: controller.selectedCity.isEmpty
                ? null
                : controller.selectedCity.value,
            onChanged: (String? newValue) {
              controller.selectedCity.value = newValue!;
            },
            items: [
              'Karachi',
              'Hyderabad',
              'Sukkur',
              'Larkana',
              'Nawabshah',
              'Mirpur Khas',
              'Jamshoro',
              'Khairpur',
              'Dadu',
              'Shikarpur',
              'Jacobabad',
              'Ghotki',
              'Tando Adam',
              'Tando Allahyar',
              'Matiari',
              'Badin',
              'Umerkot',
              'Sanghar',
              'Thatta',
              'Kandhkot',
              'Qambar Shahdadkot',
              'Kashmore',
              'Hala',
              'Sehwan',
              'Shahdadpur',
              'Kotri',
              'Mithi',
              'Tharparkar',
              'Sujawal',
              'Tando Muhammad Khan',
            ].map((String city) {
              return DropdownMenuItem<String>(
                value: city,
                child: Text(city),
              );
            }).toList(),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.location_city),
              labelText: "City",
            ),
          ),
          const SizedBox(height: ESizes.spaceBtwInputFields / 2),

          const SizedBox(height: ESizes.spaceBtwSections),

          /// Sign Up Button
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  side: MaterialStateProperty.all<BorderSide>(
                    const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator())
                    : const Text(ETexts.createAccount),
                onPressed: () => controller.signup(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

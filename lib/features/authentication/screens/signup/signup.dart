import '/features/authentication/screens/signup/widgets/signup_form.dart';
import '/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/text_strings.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ETexts.signupTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Signup Form
              ESignupForm(),

              SizedBox(height: ESizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}

import '/common/styles/spacing_styles.dart';
import '/features/authentication/screens/login/widgets/login_form.dart';
import '/features/authentication/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: ESpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title & Subtitle
              ELoginHeader(),

              /// Login Form
              ELoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/image_strings.dart';
import '../controller/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashScreenController>();

    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage(EImages.appLogo),
          height: 150,
        ),
      ),
    );
  }
}

import '/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: ESizes.appBarHeight,
      right: ESizes.defaultSpace,
      child: TextButton(
        onPressed: OnBoardingController.instance.skipPage,
        child: const Text('Skip'),
      ),
    );
  }
}

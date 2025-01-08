import '/features/authentication/screens/onBoarding/widgets/onboarding_dot_navigation.dart';
import '/features/authentication/screens/onBoarding/widgets/onboarding_next_button.dart';
import '/features/authentication/screens/onBoarding/widgets/onboarding_page.dart';
import '/features/authentication/screens/onBoarding/widgets/onboarding_skip.dart';
import '/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;

    return Scaffold(
      body: Stack(
        children: [
          /// Horizontal Scrollable Page
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: EImages.onBoardingImage1,
                title: ETexts.onBoardingTitle1,
                subTitle: ETexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: EImages.onBoardingImage2,
                title: ETexts.onBoardingTitle2,
                subTitle: ETexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: EImages.onBoardingImage3,
                title: ETexts.onBoardingTitle3,
                subTitle: ETexts.onBoardingSubTitle3,
              ),
            ],
          ),

          /// Skip Button
          const OnBoardingSkip(),

          /// Dot Navigation SmoothPageIndicator
          const OnBoardingDotNavigation(),

          /// Circular Button
          const OnBoardingNextButton()
        ],
      ),
    );
  }
}

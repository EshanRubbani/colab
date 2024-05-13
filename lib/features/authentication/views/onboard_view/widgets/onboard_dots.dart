import 'package:collab/utils/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../controllers/controller.onboarding/onboarding_controller.dart';

class OnBoardingDots extends StatelessWidget {
  const OnBoardingDots({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    return Positioned(
        bottom: 80,
        child: SmoothPageIndicator(
            effect: const ExpandingDotsEffect(
                activeDotColor: KAppColors.kPrimary, dotHeight: 8),
            controller: controller.pageController,
            onDotClicked: controller.dotNavigationClick,
            count: 3));
  }
}

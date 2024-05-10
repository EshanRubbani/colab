import 'package:collab/utils/constant/colors.dart';
import 'package:flutter/material.dart';

import '../../../controllers/controller.onboarding/onboarding_controller.dart';
class OnBoardSkipp extends StatelessWidget {
  const OnBoardSkipp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    return Positioned(
        left: 24,
        bottom: 24,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: KAppColors.kSecondary,
                minimumSize: Size(MediaQuery.of(context).size.width * 0.4,50),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))
            ),
            onPressed: () => controller.skipPage(),
            child: const Text(
              'Skip',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: KAppColors.kPrimary),
            )
        ));
  }
}

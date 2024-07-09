import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:flutter/material.dart';

import '../../../controllers/controller.onboarding/onboarding_controller.dart';

class OnBoardElevatedButton extends StatelessWidget {
  const OnBoardElevatedButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 24,
        bottom: 20,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: KAppColors.kPrimary,
                minimumSize: Size(MediaQuery.of(context).size.width * 0.4, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () => OnboardingController.instance.nextPage(),
            child: const Text(
              'Continue',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )));
  }
}

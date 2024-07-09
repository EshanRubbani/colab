
import 'package:Collab/pages/authentication/controllers/controller.onboarding/onboarding_controller.dart';
import 'package:Collab/pages/authentication/views/onboard_view/widgets/onboard_dots.dart';
import 'package:Collab/pages/authentication/views/onboard_view/widgets/onboard_elevated_button.dart';
import 'package:Collab/pages/authentication/views/onboard_view/widgets/onboard_skip_button_widget.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 25),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: controller.pageController,
              scrollBehavior: const ScrollBehavior(),
              onPageChanged: controller.updatePageIndicator,
              children: [
                OnBoardingWidget(
                  size: size,
                  title: 'Collab with others for collective funding goals',
                  subtitle:
                      'By pooling together diverse skills, networks, and financial contributions, groups can tackle larger projects, spread financial risk, and increase overall impact.',
                  image: 'onboard_one.png',
                ),
                OnBoardingWidget(
                  size: size,
                  title: 'Crowd fund to raise\nmoney',
                  subtitle:
                      ' This method has revolutionized fundraising by allowing individuals, startups, and nonprofits to reach a global audience.',
                  image: 'onboard_two.png',
                ),
                OnBoardingWidget(
                  size: size,
                  title: 'Collab with others for collective funding goals',
                  subtitle:
                      'Building together for common success is a principle that underscores the importance of collaboration and teamwork in achieving shared goals.',
                  image: 'onboard_three.png',
                ),
              ],
            ),
            const OnBoardSkipp(),
            const OnBoardingDots(),
            const OnBoardElevatedButton()
          ],
        ),
      ),
    );
  }
}

class OnBoardingWidget extends StatelessWidget {
  const OnBoardingWidget({
    super.key,
    required this.size,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final Size size;
  final String title, subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: SizedBox(
                //color: Colors.red,
                width: size.width * 0.9,
                height: size.height * 0.6,
                child: Image.asset(
                  'assets/images/onboard/onboard_container.png',
                  width: size.width * 0.8,
                  height: size.height * 0.6,
                  //  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned(
              top: 20,
              child: Container(
                width: size.width * 0.9,
                height: size.height * 0.58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      KAppColors.kWhite.withOpacity(0.1),
                      KAppColors.kWhite.withOpacity(0.5),
                      KAppColors.kWhite.withOpacity(0.9),
                      KAppColors.kWhite,
                    ],
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/onboard/$image'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Positioned(
            //   top: size.height * 0.6 - 10, // 10 is the shadow height
            //   child: Container(
            //     width: size.width * 0.8,
            //     height: 10, // Adjust the height of the shadow as needed
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: [
            //           KAppColors.kPrimary.withOpacity(0.1),
            //           KAppColors.kPrimary.withOpacity(0.5),
            //           KAppColors.kPrimary.withOpacity(0.9),
            //           KAppColors.kPrimary,
            //         ],
            //       ),
            //
            //     ),
            //   ),
            // ),
          ],
        ),
        Positioned(
          top: size.height * 0.63,
          left: 20,
          right: 20,
          child: Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        Positioned(
          top: size.height * 0.71,
          left: 20,
          right: 20,
          child: Text(
            subtitle,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

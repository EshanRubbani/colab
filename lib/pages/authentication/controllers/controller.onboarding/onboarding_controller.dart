// ignore_for_file: unrelated_type_equality_checks

import 'package:Collab/pages/authentication/views/login_or_signup_view/login_or_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();
  final pageController = PageController();
  Rx<int> currentPage = 0.obs;

  void updatePageIndicator(index) => currentPage.value = index;
  void dotNavigationClick(index) {
    currentPage.value = index;
    pageController.jumpTo(index);
  }

  void nextPage() {
    if (currentPage == 2) {
                             Get.to(()=>const LoginOrSignupScreen(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
    } else {
      int page = currentPage.value + 1;
      pageController.jumpToPage(page);
    }
  }

  void skipPage() {
                            Get.to(()=>const LoginOrSignupScreen(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
  }
}

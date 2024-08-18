import 'package:Collab/extras/common/common_button.dart';
import 'package:Collab/pages/authentication/views/login_or_signup_view/widgets/social_login_widget.dart';
import 'package:Collab/pages/authentication/views/login_view/login_screen.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/extras/utils/constant/device_size.dart';
import 'package:Collab/pages/authentication/views/phone_login/phone_login.dart';
import 'package:Collab/pages/home/guest/guest.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../signup_view/signup_screen.dart';

class LoginOrSignupScreen extends StatefulWidget {
  const LoginOrSignupScreen({super.key});

  @override
  State<LoginOrSignupScreen> createState() => _LoginOrSignupScreenState();
}

class _LoginOrSignupScreenState extends State<LoginOrSignupScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
     appBar: AppBar(
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        elevation: 0,
        actions: [
         GestureDetector(
          onTap: () =>                          Get.to(()=>const Guest(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1)),
           child: Text("Skip for now",style: TextStyle(
            color: KAppColors.kPrimary,
            fontFamily: "Popins",
            fontSize: 16,
            fontWeight: FontWeight.w500,

           ),),
         ),
         SizedBox(width: 20,)
          
        ],
      ),
      body: Responsive(
        mobile: _buildForMobile(size),
        desktop: _buildForDesktop(size),
      ),
    );
  }

  _buildForMobile(Size size) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.2,
              ),
              Image.asset(
                'assets/logo/collab_logo.png',
                width: size.width * 0.45,
                height: 200,
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              const Text(
                'Welcome. Let\'s start by creating your account or sign in if you already have one',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              ButtonWidget(
                  size: size,
                  color: KAppColors.kPrimary,
                  onTap: () {
                                            Get.to(()=>const SignupScreen(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
                  },
                  text: 'Sign up'),
              SizedBox(
                height: size.height * 0.03,
              ),
              ButtonWidget(
                size: size,
                color: KAppColors.kSecondary,
                onTap: () {
                                          Get.to(()=>const LoginScreen(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
                },
                text: 'Sign in',
                textColor: KAppColors.kPrimary,
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      //margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
                  Text(
                    ' Or continue with ',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .apply(color: Colors.grey[800], fontSizeDelta: 1.2),
                  ),
                  Expanded(
                    child: Container(
                      //margin: const EdgeInsets.only(left: 10.0),
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
             
              SocailLoginWidget(
                size: size,
                path: 'phone.png',
                onTap: () {
                                         Get.to(()=>const PhoneLogin(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildForDesktop(Size size) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, minWidth: 400),
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.2,
              ),
              Image.asset(
                'assets/logo/collab_logo.png',
                width: size.width * 0.45,
                height: 200,
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              const Text(
                'Welcome. Let\'s start by creating your account\nor sign in if you already have one',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              ButtonWidget(
                  size: size,
                  color: KAppColors.kPrimary,
                  onTap: () {
                    Get.to(() => const SignupScreen());
                  },
                  text: 'Sign up'),
              SizedBox(
                height: size.height * 0.03,
              ),
              ButtonWidget(
                color: KAppColors.kSecondary,
                onTap: () {
                  Get.to(() => const LoginScreen());
                },
                text: 'Sign in',
                textColor: KAppColors.kPrimary,
                size: size,
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      //margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
                  Text(
                    ' Or continue with ',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .apply(color: Colors.grey[800], fontSizeDelta: 1.2),
                  ),
                  Expanded(
                    child: Container(
                      //margin: const EdgeInsets.only(left: 10.0),
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              SizedBox(
                  height: 50,
                  child: SocailLoginWidget(
                    size: size,
                    path: 'google.png',
                    onTap: () {},
                  )),
              SizedBox(
                height: size.height * 0.03,
              ),
              SocailLoginWidget(
                size: size,
                path: 'phone.png',
                onTap: () {
                 Get.to(const PhoneLogin());
                },
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

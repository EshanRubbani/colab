import 'package:collab/common/common_button.dart';
import 'package:collab/features/authentication/views/login_or_signup_view/widgets/social_login_widget.dart';
import 'package:collab/features/authentication/views/login_view/login_screen.dart';
import 'package:collab/utils/constant/colors.dart';
import 'package:collab/utils/device/device_size.dart';
import 'package:flutter/cupertino.dart';
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
      body: Responsive(
        mobile: _buildForMobile(size),
        desktop: _buildForDesktop(size),
      ),
    );
  }
  _buildForMobile(Size size)
  {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              SizedBox(height: size.height * 0.2 ,),
              Image.asset('assets/logo/collab_logo.png', width: size.width * 0.45, height: 200,),
              SizedBox(height: size.height * 0.01 ,),
              const Text('Welcome. Let\'s start by creating your account or sign in if you already have one', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
              SizedBox(height: size.height * 0.03 ,),
              ButtonWidget(size: size, color: KAppColors.kPrimary, onTap: (){
                Get.to(() => const SignupScreen());
              }, text: 'Sign up'),
              SizedBox(height: size.height * 0.03 ,),
              ButtonWidget(size: size, color: KAppColors.kSecondary, onTap: (){
                Get.to(() => const LoginScreen());
              }, text: 'Sign in', textColor: KAppColors.kPrimary,),
              SizedBox(height: size.height * 0.1 ,),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      //margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
                  Text(' Or continue with ', style: Theme.of(context).textTheme.bodySmall!.apply(color: Colors.grey[800], fontSizeDelta: 1.2),),
                  Expanded(
                    child: Container(
                      //margin: const EdgeInsets.only(left: 10.0),
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03 ,),
              SocailLoginWidget(size: size, path: 'google.png', onTap: (){
                Get.snackbar('Google Login', 'Google login is not implemented yet');
              },),
            ],
          ),
        ),
      ),
    );
  }
  _buildForDesktop(Size size)
  {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              SizedBox(height: size.height * 0.2 ,),
              Image.asset('assets/logo/collab_logo.png', width: size.width * 0.45, height: 200,),
              SizedBox(height: size.height * 0.01 ,),
              const Text('Welcome. Let\'s start by creating your account\nor sign in if you already have one', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
              SizedBox(height: size.height * 0.04 ,),
              ButtonWidget(size: size, color: KAppColors.kPrimary, onTap: (){
                Get.to(() => const SignupScreen());
              }, text: 'Sign up'),
              SizedBox(height: size.height * 0.03 ,),
              ButtonWidget( color: KAppColors.kSecondary, onTap: (){
                Get.to(() => const LoginScreen());
              }, text: 'Sign in', textColor: KAppColors.kPrimary, size: size,),
              SizedBox(height: size.height * 0.1 ,),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      //margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
                  Text(' Or continue with ', style: Theme.of(context).textTheme.bodySmall!.apply(color: Colors.grey[800], fontSizeDelta: 1.2),),
                  Expanded(
                    child: Container(
                      //margin: const EdgeInsets.only(left: 10.0),
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03 ,),
              SizedBox(
                  height: 50,
                  child: SocailLoginWidget(size: size, path: 'google.png', onTap: (){},)),
              SizedBox(height: size.height * 0.03 ,),
            ],
          ),
        ),
      ),
    );
  }
}



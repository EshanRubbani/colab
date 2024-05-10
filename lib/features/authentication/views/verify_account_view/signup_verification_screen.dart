import 'package:collab/common/common_button.dart';
import 'package:collab/features/authentication/views/create_new_password/create_new_password_screen.dart';
import 'package:collab/features/authentication/views/login_or_signup_view/widgets/social_login_widget.dart';
import 'package:collab/features/authentication/views/login_view/login_screen.dart';
import 'package:collab/utils/constant/colors.dart';
import 'package:collab/utils/device/device_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignupVerificationScreen extends StatefulWidget {
  const SignupVerificationScreen({super.key});

  @override
  State<SignupVerificationScreen> createState() =>
      _SignupVerificationScreenState();
}

class _SignupVerificationScreenState extends State<SignupVerificationScreen> {
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
  _buildForMobile(final size)
  {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.06,
              ),
              Image.asset(
                'assets/logo/collab_logo.png',
                width: size.width * 0.4,
                height: 200,
              ),
              SizedBox(
                height: size.height * 0.002,
              ),
              const Text(
                'Verify Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              const Text(
                'Code has been sent to John@gmail.com.\nEnter code to verify your account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Column(
              //         children: [
              //           Expanded(
              //             child: Text('First Name', style: TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.black,
              //             ),),
              //           ),
              //           Expanded(
              //             child: TextField(
              //               decoration: InputDecoration(
              //                 hintText: 'First Name',
              //                 hintStyle: TextStyle(color: Colors.grey[400]),
              //                 border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(10.0),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(width: 10,),
              //     Expanded(
              //       child: Column(
              //         children: [
              //           Expanded(
              //             child: Text('Last Name', style: TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.black,
              //             ),),
              //           ),
              //           Expanded(
              //             child: TextField(
              //               decoration: InputDecoration(
              //                 hintText: 'Last Name',
              //                 hintStyle: TextStyle(color: Colors.grey[400]),
              //                 border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(10.0),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: size.height * 0.03,
              ),
              const FieldText(
                text: 'Enter Code',
              ),
              SizedBox(
                height: size.height * 0.004,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: '04 Digits Code',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),

              // SizedBox(height: size.height * 0.02,),
              // const FieldText(text: 'Password',),
              // SizedBox(height: size.height * 0.004 ,),
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: 'Password',
              //     hintStyle: TextStyle(color: Colors.grey[400]),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //   ),
              // ),
              // SizedBox(height: size.height * 0.02 ,),
              // const FieldText(text: 'Confirm Password',),
              // SizedBox(height: size.height * 0.004 ,),
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: 'Password',
              //     hintStyle: TextStyle(color: Colors.grey[400]),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: size.height * 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t receive code?  ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: KAppColors.kBlack,
                    ),
                  ),
                  Text(
                    'Resend Code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: KAppColors.kAccent,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend code in 00:59 ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: KAppColors.kBlack,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              ButtonWidget(
                  size: size,
                  color: KAppColors.kPrimary,
                  onTap: () {
                    Get.to(() => const CreateNewPasswordScreen());
                  },
                  text: 'Verify Account'),
              SizedBox(
                height: size.height * 0.07,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text('Already have an account? ', style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.grey[800]),),
              //     GestureDetector(
              //       onTap: ()
              //       {
              //         Get.to(()=> const LoginScreen());
              //       },
              //       child: Text('Sign in', style: Theme.of(context).textTheme.titleSmall!.apply(
              //           fontSizeDelta: 3,
              //           color: KAppColors.kPrimary),),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
  _buildForDesktop(final size)
  {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.06,
              ),
              Image.asset(
                'assets/logo/collab_logo.png',
                width: size.width * 0.4,
                height: 200,
              ),
              SizedBox(
                height: size.height * 0.002,
              ),
              const Text(
                'Verify Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              const Text(
                'Code has been sent to John@gmail.com.\nEnter code to verify your account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Column(
              //         children: [
              //           Expanded(
              //             child: Text('First Name', style: TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.black,
              //             ),),
              //           ),
              //           Expanded(
              //             child: TextField(
              //               decoration: InputDecoration(
              //                 hintText: 'First Name',
              //                 hintStyle: TextStyle(color: Colors.grey[400]),
              //                 border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(10.0),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(width: 10,),
              //     Expanded(
              //       child: Column(
              //         children: [
              //           Expanded(
              //             child: Text('Last Name', style: TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.black,
              //             ),),
              //           ),
              //           Expanded(
              //             child: TextField(
              //               decoration: InputDecoration(
              //                 hintText: 'Last Name',
              //                 hintStyle: TextStyle(color: Colors.grey[400]),
              //                 border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(10.0),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: size.height * 0.03,
              ),
              const FieldText(
                text: 'Enter Code',
              ),
              SizedBox(
                height: size.height * 0.004,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: '04 Digits Code',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),

              // SizedBox(height: size.height * 0.02,),
              // const FieldText(text: 'Password',),
              // SizedBox(height: size.height * 0.004 ,),
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: 'Password',
              //     hintStyle: TextStyle(color: Colors.grey[400]),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //   ),
              // ),
              // SizedBox(height: size.height * 0.02 ,),
              // const FieldText(text: 'Confirm Password',),
              // SizedBox(height: size.height * 0.004 ,),
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: 'Password',
              //     hintStyle: TextStyle(color: Colors.grey[400]),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: size.height * 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t receive code?  ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: KAppColors.kBlack,
                    ),
                  ),
                  Text(
                    'Resend Code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: KAppColors.kAccent,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend code in 00:59 ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: KAppColors.kBlack,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              ButtonWidget(
                  size: size,
                  color: KAppColors.kPrimary,
                  onTap: () {
                    Get.to(() => const CreateNewPasswordScreen());
                  },
                  text: 'Verify Account'),
              SizedBox(
                height: size.height * 0.07,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text('Already have an account? ', style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.grey[800]),),
              //     GestureDetector(
              //       onTap: ()
              //       {
              //         Get.to(()=> const LoginScreen());
              //       },
              //       child: Text('Sign in', style: Theme.of(context).textTheme.titleSmall!.apply(
              //           fontSizeDelta: 3,
              //           color: KAppColors.kPrimary),),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FieldText extends StatelessWidget {
  const FieldText({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

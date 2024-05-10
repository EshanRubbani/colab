import 'package:collab/common/common_button.dart';
import 'package:collab/common/common_textfield.dart';
import 'package:collab/features/authentication/views/login_or_signup_view/widgets/social_login_widget.dart';
import 'package:collab/features/authentication/views/signup_view/signup_screen.dart';
import 'package:collab/features/main/views/home/home_screen.dart';
import 'package:collab/utils/constant/colors.dart';
import 'package:collab/utils/device/device_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../forgot_password_view/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  bool isObscure = true;



  void signUserIn() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //pop the loading circle
      Navigator.pop(context);
      Get.to(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);

      genericErrorMessage(e.code);
    }
  }

  void genericErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


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
                'Welcome. Let\'s start by creating your account or sign in if you already have one.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              const FieldText(
                text: 'Email',
              ),
              SizedBox(
                height: size.height * 0.004,
              ),
               TextFormField(
                 controller: emailController,
                 keyboardType: TextInputType.emailAddress,
                 textInputAction: TextInputAction.next,

                 onSaved: (email) {},
                 decoration: InputDecoration(
                   hintText: "Email",
                   hintStyle: TextStyle(color: Colors.grey[400]),
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10.0),
                   ),
                 ),

               ),
              SizedBox(
                height: size.height * 0.02,
              ),
              const FieldText(
                text: 'Password',
              ),
              TextFormField(


                controller: passwordController,
                textInputAction: TextInputAction.next,
                obscureText: isObscure,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[500],
                    ),
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                  ),
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const ForgotPasswordScreen());
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: KAppColors.kAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              ButtonWidget(
                  size: size,
                  color: KAppColors.kPrimary,
                  onTap: () {
                    signUserIn();
                  },
                  text: 'Sign in'),
              SizedBox(
                height: size.height * 0.07,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: Colors.grey[800]),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const SignupScreen());
                    },
                    child: Text(
                      'Sign up',
                      style: Theme.of(context).textTheme.titleSmall!.apply(
                          fontSizeDelta: 3, color: KAppColors.kPrimary),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }
  _buildForDesktop(Size size)
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
                'Welcome. Let\'s start by creating your account or sign in if you already have one.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              const FieldText(
                text: 'Email',
              ),
              SizedBox(
                height: size.height * 0.004,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              const FieldText(
                text: 'Password',
              ),
              TextField(
                controller: passwordController,
                obscureText: isObscure,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[400],
                    ),
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                  ),
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => const ForgotPasswordScreen());
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: KAppColors.kAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              ButtonWidget(
                  size: size,
                  color: KAppColors.kPrimary,
                  onTap: () {
                    signUserIn();
                  },
                  text: 'Sign in'),
              SizedBox(
                height: size.height * 0.07,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: Colors.grey[800]),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const SignupScreen());
                    },
                    child: Text(
                      'Sign up',
                      style: Theme.of(context).textTheme.titleSmall!.apply(
                          fontSizeDelta: 3, color: KAppColors.kPrimary),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
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


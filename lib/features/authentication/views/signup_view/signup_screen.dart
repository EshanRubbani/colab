import 'package:collab/common/common_button.dart';
import 'package:collab/features/authentication/views/login_or_signup_view/widgets/social_login_widget.dart';
import 'package:collab/features/authentication/views/login_view/login_screen.dart';
import 'package:collab/features/authentication/views/verify_account_view/signup_verification_screen.dart';
import 'package:collab/utils/constant/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common/common_textfield.dart';
import '../../../../utils/device/device_size.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();
  bool isObscure = true;
  bool isObs = true;
  // Sign Up Button Logic

  void signUserUp() async {
    try {
      // check if both password and confirm pasword is same

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      success();
    } on FirebaseAuthException catch (e) {
      //pop the loading circle

      genericErrorMessage(e.code);
    }
  }

  void success() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              "Account Created Successfully! Please Verify Your Account!."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Get.to(() => const SignupVerificationScreen());
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Container(
            constraints: isDesktop ? const BoxConstraints(maxWidth: 400) : null,
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
                  'Register',
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
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldText(
                          text: 'First Name',
                        ),
                        SizedBox(
                          height: size.height * 0.004,
                        ),
                        SizedBox(
                          width: isDesktop
                              ? size.width * 0.13
                              : size.width / 2 - 40,
                          child: const CommonTextField(
                            hintText: 'First Name',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: size.width * 0.032,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldText(
                          text: 'Last Name',
                        ),
                        SizedBox(
                          height: size.height * 0.004,
                        ),
                        SizedBox(
                            width: isDesktop
                                ? size.width * 0.13
                                : size.width / 2 - 50,
                            child: const CommonTextField(
                              hintText: 'Last Name',
                            )),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
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
                SizedBox(
                  height: size.height * 0.004,
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
                  height: size.height * 0.02,
                ),
                const FieldText(
                  text: 'Confirm Password',
                ),
                SizedBox(
                  height: size.height * 0.004,
                ),
                TextFormField(
                  obscureText: isObs,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObs
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey[500],
                      ),
                      onPressed: () {
                        setState(() {
                          isObs = !isObs;
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
                  height: size.height * 0.03,
                ),
                ButtonWidget(
                    size: size,
                    color: KAppColors.kPrimary,
                    onTap: () {
                      const snackBar = SnackBar(
                        content: Text('Please Enter Valid Email and Password!'),
                      );
                      setState(() {
                        if (emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          signUserUp();
                        }
                      });

                      //Get.to(() => const SignupVerificationScreen());
                    },
                    text: 'Register'),
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
                        Get.to(() => const LoginScreen());
                      },
                      child: Text(
                        'Sign in',
                        style: Theme.of(context).textTheme.titleSmall!.apply(
                            fontSizeDelta: 3, color: KAppColors.kPrimary),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildForMobile(final size) {
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
                'Register',
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
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldText(
                        text: 'First Name',
                      ),
                      SizedBox(
                        height: size.height * 0.004,
                      ),
                      SizedBox(
                        width: size.width / 2 - 30,
                        child: const CommonTextField(
                          hintText: 'First Name',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: size.width * 0.032,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldText(
                        text: 'Last Name',
                      ),
                      SizedBox(
                        height: size.height * 0.004,
                      ),
                      SizedBox(
                          width: size.width / 2 - 20,
                          child: const CommonTextField(
                            hintText: 'Last Name',
                          )),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              const FieldText(
                text: 'Email',
              ),
              SizedBox(
                height: size.height * 0.004,
              ),
              const CommonTextField(hintText: 'Email'),
              SizedBox(
                height: size.height * 0.02,
              ),
              const FieldText(
                text: 'Password',
              ),
              SizedBox(
                height: size.height * 0.004,
              ),
              TextFormField(
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
                height: size.height * 0.02,
              ),
              const FieldText(
                text: 'Confirm Password',
              ),
              SizedBox(
                height: size.height * 0.004,
              ),
              TextField(
                obscureText: isObs,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObs
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[500],
                    ),
                    onPressed: () {
                      setState(() {
                        isObs = !isObs;
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
                height: size.height * 0.03,
              ),
              ButtonWidget(
                  size: size,
                  color: KAppColors.kPrimary,
                  onTap: () {
                    Get.to(() => const SignupVerificationScreen());
                  },
                  text: 'Sign up'),
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
                      Get.to(() => const LoginScreen());
                    },
                    child: Text(
                      'Sign in',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .apply(fontSizeDelta: 3, color: KAppColors.kPrimary),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildForDesktop(final size) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400), // Limit max width
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
                'Register',
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
              // Row(
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const FieldText(
              //           text: 'First Name',
              //         ),
              //         SizedBox(
              //           height: size.height * 0.004,
              //         ),
              //         SizedBox(
              //           width: size.width * 0.13,
              //           child: const CommonTextField(
              //             hintText: 'First Name',
              //           ),
              //         ),
              //       ],
              //     ),
              //     SizedBox(
              //       width: size.width * 0.032,
              //     ),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const FieldText(
              //           text: 'Last Name',
              //         ),
              //         SizedBox(
              //           height: size.height * 0.004,
              //         ),
              //         SizedBox(
              //           width: size.width * 0.13,
              //           child: const CommonTextField(
              //             hintText: 'Last Name',
              //           )
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              SizedBox(
                height: size.height * 0.02,
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
                cursorColor: KAppColors.kBorderPrimary,
                onSaved: (email) {},
                style: TextStyle(),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              const FieldText(
                text: 'Password',
              ),
              SizedBox(
                height: size.height * 0.004,
              ),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                obscureText: true,
                cursorColor: KAppColors.kBorderSecondary,
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
                height: size.height * 0.02,
              ),
              const FieldText(
                text: 'Confirm Password',
              ),
              SizedBox(
                height: size.height * 0.004,
              ),
              TextField(
                obscureText: isObs,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObs
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey[500],
                    ),
                    onPressed: () {
                      setState(() {
                        isObs = !isObs;
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
                height: size.height * 0.03,
              ),
              ButtonWidget(
                  size: size,
                  color: KAppColors.kPrimary,
                  onTap: () {
                    Get.to(() => const SignupVerificationScreen());
                  },
                  text: 'Sign up'),
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
                      Get.to(() => const LoginScreen());
                    },
                    child: Text(
                      'Sign in',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .apply(fontSizeDelta: 3, color: KAppColors.kPrimary),
                    ),
                  ),
                ],
              ),
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
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

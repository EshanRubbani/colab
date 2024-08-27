import 'dart:async';

import 'package:Collab/extras/common/common_button.dart';
import 'package:Collab/main.dart';
import 'package:Collab/pages/authentication/views/create_new_password/create_new_password_screen.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/extras/utils/constant/device_size.dart';
import 'package:Collab/pages/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SigninVerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const SigninVerificationScreen({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<SigninVerificationScreen> createState() =>
      _SigninVerificationScreenState();
}

class _SigninVerificationScreenState extends State<SigninVerificationScreen> {
  final TextEditingController codeController = TextEditingController();
  int _start = 59;
  late Timer _timer;
  late String _verificationId;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _resendCode() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Sign in the user automatically if the code is instantly retrieved
          await _auth.signInWithCredential(credential);
          Get.offAll(() => const HomeScreen());
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Verification Failed', e.message ?? 'Unknown error', colorText: Colors.red);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _start = 59; // Reset timer
            startTimer(); // Restart timer
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Store the verificationId if needed for later use
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  Future<void> _verifyCode() async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: codeController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.snackbar('Success', 'Logged In Successfully', colorText: Colors.green);
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
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

  Widget _buildForMobile(Size size) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.06),
              Image.asset(
                'assets/logo/collab_logo.png',
                width: size.width * 0.4,
                height: 200,
              ),
              SizedBox(height: size.height * 0.002),
              const Text(
                'Verify Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.03),
              Text(
                'Code has been sent to ${widget.phoneNumber}.\nEnter code to verify your account',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.03),
              const FieldText(text: 'Enter Code'),
              SizedBox(height: size.height * 0.004),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  hintText: '6 Digits Code',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              if (_start > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Resend code in ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: KAppColors.kBlack,
                      ),
                    ),
                    Text(
                      '00:$_start',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: KAppColors.kBlack,
                      ),
                    ),
                  ],
                ),
              if (_start == 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Didn\'t receive code? ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: KAppColors.kBlack,
                      ),
                    ),
                    GestureDetector(
                      onTap: _resendCode,
                      child: const Text(
                        'Resend Code',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: KAppColors.kAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: size.height * 0.03),
              ButtonWidget(
                size: size,
                color: KAppColors.kPrimary,
                onTap: _verifyCode,
                text: 'Verify Account',
              ),
              SizedBox(height: size.height * 0.07),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForDesktop(Size size) {
    // Implement desktop UI if necessary
    return Center(child: Text('Desktop view not implemented'));
  }
}

class FieldText extends StatelessWidget {
  final String text;
  const FieldText({Key? key, required this.text}) : super(key: key);
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

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Collab/extras/common/common_button.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/extras/utils/constant/device_size.dart';
import 'package:Collab/extras/utils/res.dart';
import 'package:Collab/pages/authentication/views/profile_image/phone/phone_profile_imageD.dart';
import 'package:Collab/pages/authentication/views/profile_image/phone/phone_profile_imageM.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupVerificationScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String firstName;
  final String lastName;

  const SignupVerificationScreen({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
  }) : super(key: key);

  @override
  State<SignupVerificationScreen> createState() =>
      _SignupVerificationScreenState();
}

class _SignupVerificationScreenState extends State<SignupVerificationScreen> {
  final TextEditingController codeController = TextEditingController();
  int _start = 59;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
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

  Future<void> createUserDocument(PhoneAuthCredential userCredential) async {
    try {
      print("Inside user details loop");
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.phoneNumber)
          .set({
        'email': widget.phoneNumber,
        'firstName': widget.firstName,
        'lastName': widget.lastName,
        'timestamp': Timestamp.now(),
        'userIMG': "",
        'userUID': FirebaseAuth.instance.currentUser!.uid,
      });
      print("Firestore user details done");
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  void success() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
              "Account Created Successfully! \nPlease Upload Profile Image!."),
          actions: [
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Get.to(() => ResponsiveNess(
                      desktop: PhoneProfileImageD(
                        phoneNumber: widget.phoneNumber,
                      ),
                      mobile: PhoneProfileImageM(
                        phoneNumber: widget.phoneNumber,
                      ),
                    ));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        desktop: _buildForDesktop(size),
        mobile: _buildForMobile(size),
      

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
                'assets/logo/Collab_logo.png',
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
              SizedBox(height: size.height * 0.06),
              Image.asset(
                'assets/logo/Collab_logo.png',
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

  Future<void> _resendCode() async {
    setState(() {
      _start = 59;
      startTimer();
    });
    // Implement resend code functionality here
  }

  Future<void> _verifyCode() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: codeController.text.trim(),
      );
      // Sign in with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Create user document
      await createUserDocument(credential);
      // Successful event
      Navigator.pop(context);
      success();
    } catch (e) {
      Navigator.pop(context);
      Get.snackbar(e.toString(), 'Error', colorText: Colors.red);
    }
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

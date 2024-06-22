import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/res.dart';
import 'package:collab/pages/authentication/views/login_view/login_screen.dart';
import 'package:collab/pages/authentication/views/verify_account_view/signin_verification_screen.dart';
import 'package:collab/pages/authentication/views/verify_account_view/signup_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveNess(mobile: buildFormobile(context), desktop: buildForDesktop(context))    );
  }
}

Widget buildFormobile(context) {
   TextEditingController phoneController = TextEditingController();

  return Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 500,
              width: double.infinity,
              child: Center(
                child: Image.asset("assets/logo/collab_logo.png"),
              ),
            ),
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        hintText: "+92 3xxxxxxxxx",
                        suffixIcon: Icon(Icons.phone),
                        focusColor: KAppColors.kPrimary,
                        fillColor: KAppColors.kPrimary,
                        suffixIconColor: KAppColors.kPrimary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KAppColors.kPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        
                        phoneNumber: phoneController.text.trim(),
                        timeout: const Duration(seconds: 60),
                        verificationCompleted: (PhoneAuthCredential credential) async {
                          await FirebaseAuth.instance.signInWithCredential(credential);
                          // Handle automatic verification
                        },
                        verificationFailed: (FirebaseAuthException ex) {
                          // Handle verification failure
                          Get.snackbar('Error', ex.message ?? 'Verification failed');
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          Get.to(SigninVerificationScreen(verificationId: verificationId, phoneNumber: phoneController.text));
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {
                          // Auto retrieval timeout
                        },
                        forceResendingToken: null,
                        
                                          
                      );
                    },
                    child: const Text( 
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'OR',
                    style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const LoginScreen());
                        },
                        child: Text(
                          'Sign in Using Email....',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .apply(fontSizeDelta: 3, color: KAppColors.kPrimary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

}





Widget buildForDesktop(context) {
   TextEditingController phoneController = TextEditingController();

  return Center(
    child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width / 2,
          
          ),
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Center(
                  child: Image.asset("assets/logo/collab_logo.png"),
                ),
              ),
              SizedBox(
                height: 250,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                          hintText: "+92 3xxxxxxxxx",
                          suffixIcon: Icon(Icons.phone),
                          focusColor: KAppColors.kPrimary,
                          fillColor: KAppColors.kPrimary,
                          suffixIconColor: KAppColors.kPrimary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KAppColors.kPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          
                          phoneNumber: phoneController.text.trim(),
                          timeout: const Duration(seconds: 60),
                          verificationCompleted: (PhoneAuthCredential credential) async {
                            await FirebaseAuth.instance.signInWithCredential(credential);
                            // Handle automatic verification
                          },
                          verificationFailed: (FirebaseAuthException ex) {
                            // Handle verification failure
                            Get.snackbar('Error', ex.message ?? 'Verification failed');
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            Get.to(SigninVerificationScreen(verificationId: verificationId, phoneNumber: phoneController.text,));
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {
                            // Auto retrieval timeout
                          },
                          forceResendingToken: null,
                          
                                            
                        );
                      },
                      child: const Text( 
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'OR',
                      style: Theme.of(context).textTheme.bodyLarge!.apply(color: Colors.grey[800]),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const LoginScreen());
                          },
                          child: Text(
                            'Login Using Email....',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .apply(fontSizeDelta: 3, color: KAppColors.kPrimary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
  );

}
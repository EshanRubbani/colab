import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/res.dart';
import 'package:collab/pages/authentication/views/login_view/login_screen.dart';
import 'package:collab/pages/authentication/views/signup_view/signup_screen.dart';
import 'package:collab/pages/authentication/views/verify_account_view/signup_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneSignup extends StatefulWidget {
  const PhoneSignup({super.key});

  @override
  _PhoneSignupState createState() => _PhoneSignupState();
}

class _PhoneSignupState extends State<PhoneSignup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ResponsiveNess(
            mobile: buildFormobile(context),
            desktop: buildForDesktop(context)));
  }
}

Widget buildFormobile(context) {
  TextEditingController phoneController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

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
              Text("Phone No Sign Up"),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("First Name"),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.004,
                      ),
                      SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2 - 40,
                          child: TextFormField(
                            controller: firstNameController,
                            textInputAction: TextInputAction.next,
                            onSaved: (firstname) {},
                            decoration: InputDecoration(
                              hintText: "First Name",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.032,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Last Name"),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.004,
                      ),
                      SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2 - 50,
                          child: TextFormField(
                            controller: lastNameController,
                            textInputAction: TextInputAction.next,
                            onSaved: (lastname) {},
                            decoration: InputDecoration(
                              hintText: "Last Name",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
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
                    verificationCompleted:
                        (PhoneAuthCredential credential) async {
                      await FirebaseAuth.instance
                          .signInWithCredential(credential);
                      // Handle automatic verification
                    },
                    verificationFailed: (FirebaseAuthException ex) {
                      // Handle verification failure
                      Get.snackbar(
                          'Error', ex.message ?? 'Verification failed');
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      Get.to(SignupVerificationScreen(
                        verificationId: verificationId,
                        phoneNumber: phoneController.text,
                        firstName: firstNameController.text.toString(),
                        lastName: lastNameController.text.toString(),
                      ));
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {
                      // Auto retrieval timeout
                    },
                    forceResendingToken: null,
                  );
                },
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'OR',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .apply(color: Colors.grey[800]),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const SignupScreen());
                    },
                    child: Text(
                      'Sign Up Using Email....',
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
Widget buildForDesktop(BuildContext context) {
  TextEditingController phoneController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  return Container(

    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height,
      maxWidth: MediaQuery.of(context).size.width,
    ),
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 230,
            width: double.infinity,
            child: Center(
              child: Image.asset("assets/logo/collab_logo.png"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text(
                  "Phone No Sign Up",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: KAppColors.kPrimary),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.13,
                      child: TextFormField(
                        controller: firstNameController,
                        textInputAction: TextInputAction.next,
                        onSaved: (firstname) {},
                        decoration: InputDecoration(
                          labelText: "First Name",
                          hintText: "First Name",
                          hintStyle: TextStyle(color: KAppColors.kPrimary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.13,
                      child: TextFormField(
                        controller: lastNameController,
                        textInputAction: TextInputAction.next,
                        onSaved: (lastname) {},
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          hintText: "Last Name",
                          hintStyle: TextStyle(color: KAppColors.kPrimary),
                          fillColor: KAppColors.kPrimary,
                          focusColor: KAppColors.kPrimary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.29,
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      hintText: "+92 3xxxxxxxxx",
                      suffixIcon: Icon(Icons.phone),
                      focusColor: KAppColors.kPrimary,
                      fillColor: KAppColors.kPrimary,
                      suffixIconColor: KAppColors.kPrimary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                      verificationCompleted:
                          (PhoneAuthCredential credential) async {
                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                        // Handle automatic verification
                      },
                      verificationFailed: (FirebaseAuthException ex) {
                        // Handle verification failure
                        Get.snackbar(
                            'Error', ex.message ?? 'Verification failed');
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        Get.to(SignupVerificationScreen(
                          verificationId: verificationId,
                          phoneNumber: phoneController.text,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                        ));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        // Auto retrieval timeout
                      },
                      forceResendingToken: null,
                    );
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'OR',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(color: Colors.grey[800]),
                ),
                const SizedBox(height: 10),
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
          ),
        ],
      ),
    ),
  );
}

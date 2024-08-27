import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/extras/utils/constant/device_size.dart';
import 'package:Collab/extras/utils/res.dart';
import 'package:Collab/pages/authentication/views/login_view/login_screen.dart';
import 'package:Collab/pages/authentication/views/signup_view/signup_screen.dart';
import 'package:Collab/pages/authentication/views/verify_account_view/signup_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneSignup extends StatefulWidget {
  const PhoneSignup({super.key});

  @override
  State<PhoneSignup> createState() => _PhoneSignupState();
}

final TextEditingController phoneController = TextEditingController();
final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();

class _PhoneSignupState extends State<PhoneSignup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Responsive(
            mobile: buildFormobile(context),
            desktop: buildForDesktop(context)));
  }
}

Widget buildFormobile(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    color: Colors.white,
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/logo/collab_logo.png",
          width: MediaQuery.of(context).size.width * 0.4,
          height: 200,
        ),
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Phone No Sign Up",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KAppColors.kPrimary,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.42,
                    margin: EdgeInsets.only(right: 15),
                    child: TextField(
                      controller: firstNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: TextField(
                      controller: lastNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width * 0.9,
                child:  TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: KAppColors.kPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      });
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
                      navigator!.pop(context);
                      // Handle verification failure
                      Get.snackbar(
                          'Error', ex.message ?? 'Verification failed');
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      navigator!.pop(context);
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
              const SizedBox(height: 20),
              Text(
                'OR',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .apply(color: Colors.grey[800]),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Get.to(() => SignupScreen());
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
        ),
      ],
    ),
  );
}

Widget buildForDesktop(BuildContext context) {
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
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: KAppColors.kPrimary),
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
                          phoneNumber: phoneController.text.toString(),
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
          ),
        ],
      ),
    ),
  );
}

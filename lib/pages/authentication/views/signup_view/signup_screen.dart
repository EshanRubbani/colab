import 'package:Collab/extras/common/common_button.dart';
import 'package:Collab/extras/utils/res.dart';
import 'package:Collab/pages/authentication/views/login_view/login_screen.dart';
import 'package:Collab/pages/authentication/views/phone_signup/phone_signup.dart';
import 'package:Collab/pages/authentication/views/profile_image/profile_imageD.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/pages/authentication/views/profile_image/profile_imageM.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../extras/utils/constant/device_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  
  bool isObscure = true;
  bool isObs = true;
  // Sign Up Button Logic
void signUserUp() async {
  // Show loading circle
  showDialog(
      context: context,
      builder: (context) {
        return const Center(
            child: SpinKitChasingDots(
              color: KAppColors.kPrimary,
              size: 80,
            ),
          );
      });
  
  try {
    // Check if username is already taken
    bool isUsernameTaken = await checkIfUsernameTaken(usernameController.text);
    if (isUsernameTaken) {
      // Pop the loading circle
      navigator!.pop(context);
     Get.snackbar("Invalid UserName", "User Already Taken");
      return;
    }

    // Check if both password and confirm password are the same

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Create user document and send it to Firestore
      await createUserDocument(userCredential);

      // Successful event
      navigator!.pop(context);
      success();
   
  } on FirebaseAuthException catch (e) {
    // Pop the loading circle
    navigator!.pop(context);
    genericErrorMessage(e.code);
  }
}

// Create document name with email and save additional data
Future<void> createUserDocument(UserCredential userCredential) async {
  if (userCredential.user != null) {
    try {
      print("Inside user details loop");
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email.toString())
          .set({
        'userName': usernameController.text,
        'email': userCredential.user!.email.toString(),
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'timestamp': Timestamp.now(),
        'userIMG': "",
        'userUID': userCredential.user!.uid,
      });
      print("Firestore user details done");
    } catch (e) {
      genericErrorMessage(e.toString());
    }
  }
}

// Check if username is already taken
Future<bool> checkIfUsernameTaken(String username) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection("Users")
      .where("userName", isEqualTo: username)
      .get();

  return querySnapshot.docs.isNotEmpty;
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
                Navigator.pop(context);
                                         Get.to(()=> const ResponsiveNess(desktop: ProfileImageD(),mobile: ProfileImageM(),));
              },
              child: const Text('OK'),
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
    bool isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      body: Container(
        constraints: isDesktop ? const BoxConstraints(maxWidth: 400) : null,
        margin: isDesktop ? EdgeInsets.symmetric(horizontal: size.width * 0.06): null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           
            Image.asset(
              'assets/logo/collab_logo.png',
              width: size.width * 0.4,
              height: 200,
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
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: isDesktop
                        ? size.width * 0.13
                        : size.width * 0.40 +5,
                    child: TextFormField(
                      controller: firstNameController,
                      textInputAction: TextInputAction.next,
                      onSaved: (firstname) {},
                      decoration: InputDecoration(
                        labelText: "First Name",
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                    width: isDesktop
                        ? size.width * 0.13
                        : size.width * 0.40 +5,
                    child: TextFormField(
                      controller: lastNameController,
                      textInputAction: TextInputAction.next,
                      onSaved: (lastname) {},
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            
            Container(
              width: size.width * 0.9,
              child: TextFormField(
                controller: usernameController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSaved: (username) {},
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  labelText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            
            Container(
               width: size.width * 0.9,
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSaved: (email) {},
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            
            Container(
               width: size.width * 0.9,
              child: TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                obscureText: isObscure,
                decoration: InputDecoration(
                  labelText: 'Password',
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
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
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
            
                 
                },
                text: 'Register'),
            SizedBox(
              height: size.height * 0.02,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign Up Using....',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(color: Colors.grey[800]),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const PhoneSignup());
                  },
                  child: Text(
                    'Phone no.',
                    style: Theme.of(context).textTheme.titleSmall!.apply(
                        fontSizeDelta: 3, color: KAppColors.kPrimary),
                  ),
                ),
              ],
            ),
             
          ],
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

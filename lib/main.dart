import 'package:collab/pages/authentication/views/phone_login/phone_login.dart';
import 'package:collab/pages/authentication/views/phone_signup/phone_signup.dart';
import 'package:collab/pages/authentication/views/splash_view/splash_screen.dart';
import 'package:collab/pages/authentication/views/verify_account_view/signin_verification_screen.dart';
import 'package:collab/pages/authentication/views/verify_account_view/signup_verification_screen.dart';
import 'package:collab/pages/chatselection/widgets/chatSelectionDesk.dart';
import 'package:collab/pages/home/home_screen.dart';
import 'package:collab/pages/profile/profilepage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'extras/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CrowdFunding Group Chat v2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: HomeScreen(),
      home:  FirebaseAuth.instance.currentUser == null ? const SplashScreen() : const HomeScreen(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const SplashScreen(),
      //   '/home': (context) => const HomeScreen(),
      
      // },
      
    );
  }
}

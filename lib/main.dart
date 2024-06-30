import 'package:collab/pages/add/add.dart';
import 'package:collab/pages/authentication/views/splash_view/splash_screen.dart';
import 'package:collab/pages/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'extras/firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51PVutUDjz7PH5EWfIzGVIkLH8LJ3Yd8Gn27FjBqidpNt6mNgtynDv5FUIxN01UfQ9e4Up5paBzqqsK7elo1ABTjl00kSJkyGgb';
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
      title: 'CrowdFunding Stripe Integrated v2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: Add(),
      home:  FirebaseAuth.instance.currentUser == null ? const SplashScreen() : const HomeScreen(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const SplashScreen(),
      //   '/home': (context) => const HomeScreen(),
      
      // },
      
    );
  }
}

import 'package:Collab/pages/authentication/views/onboard_view/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
                               Get.to(()=>const OnboardScreen(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashContent(),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/logo/collab_logo.png'),
          const SizedBox(height: 30),
          const CircularProgressIndicator(
            strokeWidth: 5,
          ),
        ],
      ),
    );
  }
}

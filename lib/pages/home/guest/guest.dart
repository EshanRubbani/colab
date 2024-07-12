import 'package:Collab/pages/home/guest/mobileGuest.dart';
import 'package:Collab/pages/authentication/views/login_or_signup_view/login_or_signup_screen.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/extras/utils/res.dart';
import 'package:Collab/pages/home/desktop_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Guest extends StatefulWidget {
  const Guest({super.key});

  @override
  State<Guest> createState() => _GuestState();
}

class _GuestState extends State<Guest> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Get.to(() => const LoginOrSignupScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        elevation: 0,
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: KAppColors.kPrimary),
              onPressed: () => Get.to(() => const LoginOrSignupScreen(),
                  transition: Transition.cupertinoDialog,
                  duration: Duration(seconds: 1)),
              child: Row(
                children: [
                  Text(
                    "Log in",
                    style: TextStyle(color: Colors.white, fontFamily: "Popins"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.login_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ],
              )),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: const ResponsiveNess(
        mobile: MobileGuest(),
        desktop: DesktopHome(),
      ),
    );
  }
}

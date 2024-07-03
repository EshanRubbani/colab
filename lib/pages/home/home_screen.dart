import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/Helper/groupchat/group.dart';
import 'package:collab/extras/utils/Helper/voting/voting_service.dart';
import 'package:collab/pages/authentication/views/login_or_signup_view/login_or_signup_screen.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/constant/navbarm.dart';
import 'package:collab/extras/utils/res.dart';
import 'package:collab/pages/chatpage/group_chat_page.dart';
import 'package:collab/pages/home/desktop_home.dart';
import 'package:collab/pages/home/mobile_home.dart';
import 'package:collab/pages/home/paymentButton.dart';
import 'package:collab/pages/profile/profilepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_outlined),
            color: KAppColors.kPrimary,
          ),
          IconButton(
            onPressed: () {
              signUserOut();
            },
            icon: const Icon(Icons.logout_outlined),
            color: KAppColors.kPrimary,
          ),
        ],
      ),
      body: const ResponsiveNess(
        mobile: MobileHome(),
        desktop: DesktopHome(),
      ),
    );
  }


}

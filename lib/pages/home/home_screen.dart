import 'dart:convert';

import 'package:Collab/extras/utils/constant/device_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Collab/extras/utils/Helper/firestore.dart';
import 'package:Collab/extras/utils/Helper/groupchat/group.dart';
import 'package:Collab/extras/utils/Helper/voting/voting_service.dart';
import 'package:Collab/pages/authentication/views/login_or_signup_view/login_or_signup_screen.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/extras/utils/constant/navbarm.dart';
import 'package:Collab/extras/utils/res.dart';
import 'package:Collab/pages/chatpage/group_chat_page.dart';
import 'package:Collab/pages/home/desktop_home.dart';
import 'package:Collab/pages/home/mobile_home.dart';
import 'package:Collab/pages/home/paymentButton.dart';
import 'package:Collab/pages/profile/profilepage.dart';
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
                          Get.to(()=>const LoginOrSignupScreen(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
  }

 

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        backgroundColor:Colors.white,
        shadowColor: Colors.white,
     
        elevation: 0,
        actions: [
         
          IconButton(
            onPressed: () {
              signUserOut();
            },
            icon: const Icon(Icons.logout_outlined),
            color: KAppColors.kPrimary,
          ),
        ],
      ),
      body:  Responsive(
        mobile: MobileHome(),
        desktop: DesktopHome(),
      ),
    );
  }


}

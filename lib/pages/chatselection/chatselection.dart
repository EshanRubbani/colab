// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:collab/pages/chatselection/widgets/chatSelectionDesk.dart';
import 'package:collab/pages/chatselection/widgets/chatSelectionMobile.dart';
import 'package:collab/pages/home/home_screen.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatSelectScreen extends StatefulWidget {
  const ChatSelectScreen({super.key});

  @override
  State<ChatSelectScreen> createState() => _ChatSelectScreenState();
}

class _ChatSelectScreenState extends State<ChatSelectScreen> {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        appBar: AppBar(
          elevation: 5,
          surfaceTintColor: Colors.white,
          shadowColor: KAppColors.kLightGrey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          backgroundColor: Colors.white,
          centerTitle: true,
          primary: true,
          title: const Text(
            "Chat",
            style: TextStyle(color: KAppColors.kPrimary),
          ),
          leading: IconButton(
            onPressed: () {
              Get.to(() => const HomeScreen());
            },
            icon: const Icon(
              CupertinoIcons.back,
              color: KAppColors.kPrimary,
            ),
          ),
        ),
        body: const ResponsiveNess(
          mobile: ChatSelectionMobile(),
          desktop: ChatSelectionDesk(),
        ));
  }
}

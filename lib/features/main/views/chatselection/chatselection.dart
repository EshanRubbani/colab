import 'package:collab/features/main/views/home/home_screen.dart';
import 'package:collab/utils/constant/colors.dart';
import 'package:collab/utils/device/device_size.dart';
import 'package:collab/utils/navbar.dart';
import 'package:collab/utils/navbarm.dart';
import 'package:collab/utils/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ChatSelectScreen extends StatefulWidget {
  const ChatSelectScreen({super.key});

  @override
  State<ChatSelectScreen> createState() => _ChatSelectScreenState();
}

class _ChatSelectScreenState extends State<ChatSelectScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
        body: ResponsiveNess(
          mobile: _buildForMobile(size),
          desktop: _buildForDesktop(size),
        ));
  }
}

_buildForMobile(Size size) {
  return Scaffold(
    body: Container(
      color: Colors.white,
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 40, bottom: 10),
              width: 360,
              height: 56,
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFFCBD5E1),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: SizedBox(
                      child: TextField(
                        showCursor: false,
                        decoration: InputDecoration(
                            hintText: 'Select Users to Send Message',
                            border: InputBorder.none),
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0.09,
                        ),
                        enableInteractiveSelection: true,
                        onTap: menubar,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: const Icon(CupertinoIcons.search),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          menubar()
        ],
      ),
    ),
  );
}

_buildForDesktop(Size size) {
  return Scaffold(
    body: Container(
      color: Colors.white,
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 40, bottom: 10),
              width: 360,
              height: 56,
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFFCBD5E1),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: SizedBox(
                      child: TextField(
                        showCursor: false,
                        decoration: InputDecoration(
                            hintText: 'Select Users to Send Message',
                            border: InputBorder.none),
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0.09,
                        ),
                        enableInteractiveSelection: true,
                        onTap: menubar,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: const Icon(CupertinoIcons.search),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          menubar()
        ],
      ),
    ),
  );
}

menubar() {
  return Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade500)),
    height: 250,
    width: 360,
    child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              minimumSize: const Size(345, 55),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade500),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {},
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  //color: Colors.red,
                  child: Image.asset('assets/images/hat.png'),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "All Group Members",
                  style: TextStyle(color: KAppColors.kPrimary),
                ),
                Spacer(),
                Container(
                    height: 20,
                    width: 20,
                    //color: Colors.red,
                    child: GestureDetector(
                      child: const Icon(CupertinoIcons.forward),
                      onTap: () {},
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              minimumSize: const Size(345, 55),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade500),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {},
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  //color: Colors.red,
                  child: Image.asset('assets/images/hat.png'),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Male",
                  style: TextStyle(color: KAppColors.kPrimary),
                ),
                Spacer(),
                Container(
                    height: 20,
                    width: 20,
                    //color: Colors.red,
                    child: GestureDetector(
                      child: const Icon(CupertinoIcons.forward),
                      onTap: () {},
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              minimumSize: const Size(345, 55),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade500),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {},
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  //color: Colors.red,
                  child: Image.asset('assets/images/hat.png'),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Female",
                  style: TextStyle(color: KAppColors.kPrimary),
                ),
                Spacer(),
                Container(
                    height: 20,
                    width: 20,
                    //color: Colors.red,
                    child: GestureDetector(
                      child: const Icon(CupertinoIcons.forward),
                      onTap: () {},
                    )),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

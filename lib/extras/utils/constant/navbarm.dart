import 'package:Collab/pages/add/add.dart';
import 'package:Collab/pages/chatselection/chatselection.dart';
import 'package:Collab/pages/discover/discover_screen.dart';
import 'package:Collab/pages/home/home_screen.dart';
import 'package:Collab/pages/profile/profilepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavm extends StatefulWidget {
  final int index;

  const BottomNavm({
    super.key,
    required this.index,
  });

  @override
  State<BottomNavm> createState() => _BottomNavmState();
}

class _BottomNavmState extends State<BottomNavm> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            //width: 380,
            constraints:  BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.8,maxWidth: MediaQuery.of(context).size.width * 0.9,minHeight: 75,maxHeight: 75,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(75),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3), // Adjust shadow color
                  spreadRadius: 3, // Adjust spread
                  blurRadius: 5, // Adjust blur
                  offset: const Offset(0, 3), // Adjust offset for direction
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GNav(
                tabActiveBorder:
                // Border.all()
                    Border.all(color: Colors.deepPurple, width: 1.8,style: BorderStyle.solid),
                style: GnavStyle.google,
                padding: EdgeInsets.all(8),
                gap: 15,
                activeColor: Colors.deepPurple,
                tabs: [
                  GButton(
                    icon: CupertinoIcons.home,
                    text: '  Home',
                    onPressed: () {
                     Get.to(()=>const HomeScreen(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
                    },
                  ),
                  GButton(
                    icon: CupertinoIcons.compass,
                    text: 'Discover',
                    onPressed: () {
                       Get.to(()=>const DiscoverScreen(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
                    },
                  ),
                  GButton(
                    icon: CupertinoIcons.add,
                    text: 'New',
                    onPressed: () {
                                              Get.to(()=>const Add(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
                    },
                  ),
                  GButton(
                    icon: CupertinoIcons.chat_bubble,
                    text: 'Chat',
                    onPressed: () {
                                              Get.to(()=>const ChatSelectScreen(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
                    },
                  ),
                  GButton(
                    icon: CupertinoIcons.profile_circled,
                    text: 'Profile',
                    onPressed: () {
                                               Get.to(()=>const ProfilePage(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
                    },
                  )
                ],
                selectedIndex: widget.index,
                // onTabChange: (index) {
                //   setState(() {
                //     _selectedIndex = index;
                //   });
                // },
              ),
            ),
          ),
        )
      ],
    );
  }
}

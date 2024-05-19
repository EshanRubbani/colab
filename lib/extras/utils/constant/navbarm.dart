import 'package:collab/pages/add/add.dart';
import 'package:collab/pages/chatselection/chatselection.dart';
import 'package:collab/pages/discover/discover_screen.dart';
import 'package:collab/pages/home/home_screen.dart';
import 'package:collab/pages/authentication/views/profile_image/profile_image.dart';
import 'package:collab/pages/profile/profilepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.all(16.0),
          child: Container(
            //width: 380,
            constraints: const BoxConstraints(minWidth: 200.0),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                child: GNav(
                  tabActiveBorder:
                      Border.all(color: Colors.deepPurple, width: 2.5),
                  style: GnavStyle.google,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width *
                        0.005, // Example: 4% of width
                    vertical: MediaQuery.of(context).size.height *
                        0.02, // Example: 2% of height
                  ),
                  gap: 15,
                  activeColor: Colors.deepPurple,
                  tabs: [
                    GButton(
                      icon: CupertinoIcons.home,
                      text: 'Home',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const HomeScreen();
                            },
                          ),
                        );
                      },
                    ),
                    GButton(
                      icon: CupertinoIcons.compass,
                      text: 'Discover',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const DiscoverScreen();
                            },
                          ),
                        );
                      },
                    ),
                    GButton(
                      icon: CupertinoIcons.add,
                      text: 'New',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const Add();
                            },
                          ),
                        );
                      },
                    ),
                    GButton(
                      icon: CupertinoIcons.chat_bubble,
                      text: 'Chat',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ChatSelectScreen();
                            },
                          ),
                        );
                      },
                    ),
                    GButton(
                      icon: CupertinoIcons.profile_circled,
                      text: 'Profile',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProfilePage();
                            },
                          ),
                        );
                      },
                    )
                  ],
                  selectedIndex: widget.index,
                  // onTabChange: (index) {
                  //   setState(() {
                  //     _selectedIndex = index;
                  //   });
                  // },
                )),
          ),
        )
      ],
    );
  }
}

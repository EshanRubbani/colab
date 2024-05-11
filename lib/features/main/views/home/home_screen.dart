import 'package:collab/features/authentication/views/login_or_signup_view/login_or_signup_screen.dart';
import 'package:collab/features/main/views/discover/discover_screen.dart';
import 'package:collab/utils/constant/colors.dart';
import 'package:collab/utils/device/device_size.dart';
import 'package:collab/utils/navbar.dart';
import 'package:collab/utils/res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
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
        body: ResponsiveNess(
            mobile: _buildForMobile(size), desktop: _buildForDesktop(size)));
  }
}

_buildForMobile(Size size) {
  return Stack(
    children: [
      ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              height: size.height * 0.4,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 0.1,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.2,
                    width: size.width,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                        image: AssetImage('assets/images/home/piano.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Positioned(
                          right: 70,
                          bottom: 10,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.ios_share),
                              color: KAppColors.kPrimary,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: 10,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite_border_outlined),
                              color: KAppColors.kPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: KAppColors.kPrimary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/google.png',
                            width: 20,
                            height: 20,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'For Mobile',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vintage Piano',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 3.48,
                        width: 358,
                        child: const Center(
                          child: LinearProgressIndicator(
                            color: Colors.deepPurple,
                            value: 0.7,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 21,
                        width: 358.18,
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.gift),
                            SizedBox(
                              width: 5,
                              height: 5,
                            ),
                            Text("150\$ Backed"),
                            Expanded(
                              child: Text(
                                "70%",
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
//custom floating dock
      const Align(
        alignment: Alignment.bottomCenter,
        child: BottomNav(index: 1),
      )
    ],
  );
}

_buildForDesktop(Size size) {
  return Stack(
    clipBehavior: Clip.antiAlias,
    alignment: Alignment.center,
    children: [
      Container(
        constraints: BoxConstraints(maxWidth: 500),
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Expanded(
                child: Container(
                  constraints: BoxConstraints.expand(
                    height: size.height * 0.8,
                  ),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 0.1,
                        offset:
                            const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: size.height * 0.4,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                            image: AssetImage('assets/images/home/piano.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Positioned(
                              right: 70,
                              bottom: 10,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.ios_share),
                                  color: KAppColors.kPrimary,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 20,
                              bottom: 10,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.favorite_border_outlined),
                                  color: KAppColors.kPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: KAppColors.kPrimary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/google.png',
                                width: 20,
                                height: 20,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Home',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          const Text(
                            'Vintage Piano',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 3.48,
                            width: 350,
                            child: const Center(
                              child: LinearProgressIndicator(
                                color: Colors.deepPurple,
                                value: 0.7,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 21,
                            width: 350,
                            child: const Row(
                              children: [
                                Icon(CupertinoIcons.gift),
                                SizedBox(
                                  width: 5,
                                  height: 5,
                                ),
                                Text("150\$ Backed"),
                                Expanded(
                                  child: Text(
                                    "70%",
                                    textAlign: TextAlign.end,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
      //custom floating dock
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 400,
          child: const BottomNav(index: 0),
        ),
      )
    ],
  );
}

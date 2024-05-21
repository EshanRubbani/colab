import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/pages/authentication/views/login_or_signup_view/login_or_signup_screen.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/constant/navbar.dart';
import 'package:collab/extras/utils/constant/navbarm.dart';
import 'package:collab/extras/utils/res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.white,
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

Widget _buildForMobile(Size size) {
  final FirestoreService fireStore = FirestoreService();
  const Color kPrimary = Colors.blue; // Replace with your actual color

  return StreamBuilder<QuerySnapshot>(
    stream: fireStore.getPostsStream(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator()); // Loading
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}')); // Error
      } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('No posts available')); // No Data
      } else {
        var posts = snapshot.data!.docs;
        return Stack(
          children: [
            ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                var post = posts[index].data() as Map<String, dynamic>;
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
                        offset:
                            const Offset(0, 2), // Changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.2,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey,
                          image: DecorationImage(
                            image: NetworkImage(post['itemImg']),
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
                                  color: kPrimary,
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
                                  color: kPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: kPrimary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Image.network(
                                post['ownerDp'],
                                width: 20,
                                height: 20,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            post['ownerName'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['itemName'],
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: 3.48,
                            width: 358,
                            child: Center(
                              child: LinearProgressIndicator(
                                color: Colors.deepPurple,
                                value: post['itemPercent'] / 100,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 21,
                            width: 358.18,
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.gift),
                                const SizedBox(width: 5, height: 5),
                                Text("${post['backed']}\$ Backed"),
                                Expanded(
                                  child: Text(
                                    "${post['itemPercent']}%",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavm(index: 0),
            ),
          ],
        );
      }
    },
  );
}

_buildForDesktop(Size size) {
  return Stack(
    clipBehavior: Clip.antiAlias,
    alignment: Alignment.center,
    children: [
      Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                constraints: BoxConstraints(
                    maxHeight: size.height * 0.7, minHeight: size.height * 0.5),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.withOpacity(0.1),
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
                      height: size.height * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                        image: const DecorationImage(
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
                                icon:
                                    const Icon(Icons.favorite_border_outlined),
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
                        const SizedBox(
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
                          'Olivia Hez',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Column(
                      children: [
                        Text(
                          'Vintage Piano',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 3.48,
                          width: 300,
                          child: Center(
                            child: LinearProgressIndicator(
                              color: Colors.deepPurple,
                              value: 0.7,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 21,
                          width: 300,
                          child: Row(
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
      ),
      //custom floating dock
      const Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: 400,
          child: BottomNav(index: 0),
        ),
      )
    ],
  );
}

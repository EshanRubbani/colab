import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/Helper/groupchat/group.dart';
import 'package:collab/pages/authentication/views/login_or_signup_view/login_or_signup_screen.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/constant/navbarm.dart';
import 'package:collab/extras/utils/res.dart';
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
    final size = MediaQuery.of(context).size;
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
      body: ResponsiveNess(
        mobile: _buildForMobile(size),
        desktop: _buildForDesktop(size),
      ),
    );
  }

  Widget _buildForMobile(Size size) {
    final FirestoreService fireStore = FirestoreService();
    final user = FirebaseAuth.instance.currentUser!;
    final userIdentifier = user.email ?? user.phoneNumber;

    return StreamBuilder<QuerySnapshot>(
      stream: fireStore.getPostsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Column(
            children: [
              const Center(child: Text('No posts available')),
              const Spacer(),
              const Align(
                alignment: Alignment.bottomCenter,
                child: BottomNavm(index: 0),
              ),
            ],
          );
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
                          offset: const Offset(0, 2),
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
                                    onPressed: () async {
                                      final groupId = post['groupId'];

                                      final userDoc = await FirebaseFirestore
                                          .instance
                                          .collection('Users')
                                          .doc(userIdentifier)
                                          .get();
                                      final userData = userDoc.data();

                                      if (userData != null) {
                                        List<dynamic> joinedGroups =
                                            userData['joinedGroups'] ?? [];

                                        if (!joinedGroups.contains(groupId)) {
                                          initPaymentSheet(10,groupId, userIdentifier); // Pass the amount here
                                          
                                        }
                                      }
                                    },
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
                        const SizedBox(height: 15),
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
                                child: Image.network(
                                  post['ownerDp'],
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              post['ownerName'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Text(
                              "  ",
                              style: TextStyle(fontSize: 22),
                            ),
                            Text(
                              post['selectedItemType'],
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                            const Text(
                              "  ",
                              style: TextStyle(fontSize: 22),
                            ),
                            Text(
                              post['scope'],
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
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
                            Text(
                              post['category'],
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: KAppColors.kDarkerGrey),
                            ),
                            const SizedBox(height: 10),
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
}
_buildForDesktop(Size size) {
  final FirestoreService fireStore = FirestoreService();
  final user = FirebaseAuth.instance.currentUser!;
  final userIdentifier = user.email ?? user.phoneNumber;

  return Center(
    child: Container(
      constraints: const BoxConstraints(
        maxWidth: 500,
        minWidth: 360,
      ),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: StreamBuilder<QuerySnapshot>(
              stream: fireStore.getPostsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator()); // Loading
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}')); // Error
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No posts available')); // No Data
                } else {
                  var posts = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      var post = posts[index].data() as Map<String, dynamic>;
                      print('Image URL: ${post['itemImg']}');

                      return Container(
                        constraints: const BoxConstraints(
                          maxHeight: 420,
                          minHeight: 400,
                          maxWidth: 500,
                          minWidth: 360,
                        ),
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 0.1,
                              offset: const Offset(
                                  0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              constraints: const BoxConstraints(
                                maxHeight: 230,
                                minHeight: 230,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    post['itemImg'],
                                  ),
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
                                        onPressed: () async {
                                          final groupId = post['groupId'];

                                          final userDoc = await FirebaseFirestore
                                              .instance
                                              .collection('Users')
                                              .doc(userIdentifier)
                                              .get();
                                          final userData = userDoc.data();

                                          if (userData != null) {
                                            List<dynamic> joinedGroups =
                                                userData['joinedGroups'] ?? [];

                                            if (!joinedGroups
                                                .contains(groupId)) {
                                              // User has not joined the group yet, proceed to join
                                               initPaymentSheet(10,groupId, userIdentifier); 
                                             
                                            } else {
                                              // User already joined the group
                                              Get.snackbar(
                                                  'Info',
                                                  'You are already a member of this group',
                                                  colorText: Colors.blue);
                                            }
                                          }
                                        },
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
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                const SizedBox(width: 5),
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: KAppColors.kPrimary,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Image.network(
                                      post['ownerDp'],
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.fill,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error,
                                            color: KAppColors.kPrimary);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  post['ownerName'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Text(
                                  "  ",
                                  style: TextStyle(fontSize: 22),
                                ),
                               
                              ],
                            ),
                            // const SizedBox(height: 15),
                            
                             
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 60,
                                    ),
                                    Text(
                                      post['itemName'],
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 60,
                                    ),

                                    Text(
                                        post['category'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: KAppColors.kDarkerGrey
                                        ),
                                      ),
                                  ],
                                ),
                               
                                    Row(
                              children: [
                                SizedBox(width: 60,),
                                Text(
                                  post['selectedItemType'],
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                                const Text(
                                  "  ",
                                  style: TextStyle(fontSize: 22),
                                ),
                                Text(
                                  post['scope'],
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ],
                             ),
                             
                                 
                                
                                Center(
                                  child: SizedBox(
                                    height: 3.48,
                                    width: 340,
                                    child: Center(
                                      child: LinearProgressIndicator(
                                        color: Colors.deepPurple,
                                        value: post['itemPercent'] / 100,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Center(
                                  child: SizedBox(
                                    height: 21,
                                    width: 340,
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
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          // Custom floating dock
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(seconds: 5),
              width: 400,
              child: const BottomNavm(index: 0),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> joinGroup(groupId, String? userIdentifier) async {
   GroupFunctions()
      .addMemberToGroup(
    groupId,
    userIdentifier.toString(),
  );
  
  // Update Firestore with the new group in joinedGroups
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(userIdentifier)
      .update({
    'joinedGroups': FieldValue
        .arrayUnion([groupId]),
  });
  
  Get.snackbar(
      'Success',
      'Joined Successfully',
      colorText: Colors.green);
}
Map<String, dynamic>? paymentIntentData;

Future<void> initPaymentSheet(int amount,groupId, String? userIdentifier) async {
  try {
    paymentIntentData = await createPaymentIntent(amount.toString(), 'USD');

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        allowsDelayedPaymentMethods: true,
        paymentIntentClientSecret: paymentIntentData!['client_secret'],
        style: ThemeMode.light,
        merchantDisplayName: 'Collab CrowdFunding',
      ),
    );
    displayPaymentSheet(groupId,userIdentifier);  
  } catch (e, s) {
    if (kDebugMode) {
      print(e);
      print(s);
    }
  }
}

Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
  try {
    Map<String, dynamic> body = {
      'amount': (int.parse(amount) * 100).toString(), // Convert to String
      'currency': currency,
      'payment_method_types[]': 'card'
    };

    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      body: body,
      headers: {
        'Authorization': 'Bearer sk_test_51PVutUDjz7PH5EWf1cU6vWF8c0g2xIvYEXNwE4TdtIeVIOZRvbYJMXLNXMwfRHUWKaVDjiQrs0kuY9r5DYaASb0Y00rTgcQHZj',
        'Content-Type': 'application/x-www-form-urlencoded'
      }
    );

    return jsonDecode(response.body);
  } catch (err) {
    if (kDebugMode) {
      print(err.toString());
    }
    rethrow; // Propagate the error
  }
}

void displayPaymentSheet(groupId, String? userIdentifier) async {
  try {
    await Stripe.instance.presentPaymentSheet().then((value) async {
      paymentIntentData = null;
      // Display the payment successful snackbar here
      Get.snackbar('Success', 'Payment Successful, You Have been Successfully Added to the Group', colorText: Colors.green);
       await joinGroup(groupId, userIdentifier);
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('$error $stackTrace');
      }
    });
  } on StripeException catch (e) {
    if (kDebugMode) {
      print(e);
    }
    Get.snackbar('Error', 'Payment Canceled', colorText: Colors.red);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

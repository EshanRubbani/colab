import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/Helper/groupchat/group.dart';
import 'package:collab/extras/utils/Helper/voting/voting_service.dart';
import 'package:collab/pages/authentication/views/login_or_signup_view/login_or_signup_screen.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/constant/navbarm.dart';
import 'package:collab/extras/utils/res.dart';
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
                  int itempercent = ((int.parse(post['backed'])) / (int.parse(post['cost'])) * 100).toInt();
                  
            
                  return Container(
                    
                    height: size.height * 0.4 + 30,
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
                                      final postId = await getPostIdByGroupId(groupId);
                                     
                                      
                                      try {
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
                                             print("charges: ${post['charges']}");
                                             print("groupId: ${post['groupId']}");
                                             print("backed: ${post['backed']}");
                                             print("current backers: ${post['currentbackers']}");
                                             print("item percent: ${post['itemPercent']}");
                                             print("cost: ${post['cost']}");
                                             
                                           
                                            initPaymentSheet(int.parse(post['cost']),int.parse(post['charges']), groupId,
                                                userIdentifier,postId,int.parse(post['backed']),int.parse(post['currentbackers'])); // Pass the amount here
                                          } else {
                                            Get.snackbar(
                                              'Already Joined',
                                              'You have already joined this group.',
                                            );
                                          }
                                        } else {
                                          Get.snackbar(
                                            'User Data Error',
                                            'User data not found.',
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        }
                                      } catch (e) {
                                        Get.snackbar(
                                          'Error',
                                          '$e',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
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
                                    onPressed: () {
                                    },
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
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 30),
                                Text(
                                  post['itemName'],
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  "    ",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: KAppColors.kDarkerGrey),
                                ),
                                Text(
                                  post['category'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: KAppColors.kDarkerGrey),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 30),
                                Text(
                                  post['description'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: KAppColors.kDarkerGrey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(children: [
                              const SizedBox(width: 30),
                              Container(
                                width: 400,
                                height: 30,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Raised',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5.0),
                                      child: Text('Backers',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                          )),
                                    ),
                                    Text('Goal',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        )),
                                  ],
                                ),
                              ),
                            ]),
                            Row(children: [
                              const SizedBox(width: 30),
                              Container(
                                
                                width: 400,
                                height: 30,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(post['backed'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        )),
                                        
                                    Text(
                                      '${post['currentbackers'].toString()} out of ${post['totalbackers'].toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text('${post['cost']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        )),
                                  ],
                                ),
                              ),
                            ]),
                            Center(
                              child: SizedBox(
                                height: 5,
                                width: 400,
                                child: LinearProgressIndicator(
                                  color: Colors.deepPurple,
                                  value: itempercent.toDouble(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: SizedBox(
                                height: 21,
                                width: 400,
                                child: Row(
                                  children: [
                                    const Icon(CupertinoIcons.gift),
                                    const SizedBox(width: 5, height: 5),
                                    Text("${post['backed']}\$ Backed"),
                                    Expanded(
                                      child: Text(
                                        "${itempercent.toString()} \%",
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
} // ... (rest of the code)

Widget _buildForDesktop(Size size) {
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
                                  // Positioned(
                                  //   right: 70,
                                  //   bottom: 10,
                                  //   child: PaymentButton(
                                  //     userIdentifier: userIdentifier.toString(),
                                  //     post: post,
                                  //     amount: 10.toString(),
                                  //   ),
                                  // ),
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
                                          color: KAppColors.kDarkerGrey),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 60,
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
                                Center(
                                  child: SizedBox(
                                    height: 3.48,
                                    width: 340,
                                    child: Center(
                                      child: LinearProgressIndicator(
                                        color: Colors.deepPurple,
                                        value: post['itemPercent'] ,
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

// ... (rest of the code)

Future<void> joinGroup(groupId, String? userIdentifier) async {
  print('inside joinGroup');
  GroupFunctions().addMemberToGroup(
    groupId,
    userIdentifier.toString(),
  );

  // Update Firestore with the new group in joinedGroups
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(userIdentifier)
      .update({
    'joinedGroups': FieldValue.arrayUnion([groupId]),
  });

  Get.snackbar('Success', 'Joined Successfully', colorText: Colors.green);
}


Future<void> updateData(int cost,String groupId, String? postId,int amount,int backed, int currentbackers) async {
  print("inside updateData");
print("backed: $backed");
print("charges: $amount");
int lastesbacked = backed + amount;
print("charges: $lastesbacked");

print("cost: $cost");

double lastestpercent = lastesbacked / (cost)  * 100;
  print("percent: $lastestpercent");


  // Update Firestore post data 
  print('now updating data');
  await FirebaseFirestore.instance
      .collection('Posts')
      .doc(postId)
      .update({
    'backed': lastesbacked.toString(),
    'currentbackers': (currentbackers +1).toString(),
    'itemPercent': lastestpercent.toString(),
    
  });

  if(lastestpercent >= 100.0){
    VotingService().initiateVoting(groupId);
    
    
  }


  Get.snackbar('Success', 'Data Updated Successfully', colorText: Colors.green);
}

Map<String, dynamic>? paymentIntentData;

Future<void> initPaymentSheet(int cost,
    int amount, groupId, String? userIdentifier, String? postId,int backed, int currentbackers) async {
      print("inside initpaymentsheet");
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
    displayPaymentSheet(cost,groupId, userIdentifier,postId,amount,backed,currentbackers);
  } catch (e, s) {
    if (kDebugMode) {
      print(e);
      print(s);
    }
  }
}

Future<Map<String, dynamic>> createPaymentIntent(
    String amount, String currency) async {
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
          'Authorization':
              'Bearer sk_test_51PVutUDjz7PH5EWf1cU6vWF8c0g2xIvYEXNwE4TdtIeVIOZRvbYJMXLNXMwfRHUWKaVDjiQrs0kuY9r5DYaASb0Y00rTgcQHZj',
          'Content-Type': 'application/x-www-form-urlencoded'
        });

    return jsonDecode(response.body);
  } catch (err) {
    if (kDebugMode) {
      print(err.toString());
    }
    rethrow; // Propagate the error
  }
}

void displayPaymentSheet(int cost,groupId, String? userIdentifier,String? postId,int amount,int backed, int currentbackers) async {
  print("inside displaypaymentsheet");
  try {
    await Stripe.instance.presentPaymentSheet().then((value) async {
      paymentIntentData = null;
      // Display the payment successful snackbar here
      Get.snackbar('Success',
          'Payment Successful, You Have been Successfully Added to the Group',
          colorText: Colors.green);
          print("payment successful");
      await joinGroup(groupId, userIdentifier);
      await updateData(cost,groupId,postId,amount,backed,currentbackers);
     
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


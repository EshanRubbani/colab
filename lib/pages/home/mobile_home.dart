import 'dart:convert';
import 'package:Collab/extras/utils/Helper/groupchat/group.dart';
import 'package:Collab/extras/utils/Helper/voting/voting_service.dart';
import 'package:Collab/pages/home/item_detail.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Collab/extras/utils/Helper/firestore.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/extras/utils/constant/navbarm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({Key? key}) : super(key: key);

  @override
  _MobileHomeState createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleresfresh() async {
    return await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final FirestoreService fireStore = FirestoreService();
    final user = FirebaseAuth.instance.currentUser!;
    final userIdentifier = user.email ?? user.phoneNumber;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            child: StreamBuilder<QuerySnapshot>(
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
                  return Container(
                    height: size.height - 200,
                    width: size.width,
                    child: Stack(
                      children: [
                        LiquidPullToRefresh(
                          onRefresh: _handleresfresh,
                          backgroundColor: Colors.white,
                          color: KAppColors.kPrimary,
                          height: 300,
                          showChildOpacityTransition: false,
                          child: ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              var post =
                                  posts[index].data() as Map<String, dynamic>;
                              int itempercent = ((int.parse(post['backed'])) /
                                      (int.parse(post['cost'])) *
                                      100)
                                  .toInt();
                              Future<bool> isJoined = isUserInGroup(
                                  userIdentifier.toString(), post['groupId']);
                              List<dynamic> imageList = post['itemImg'];
                              return GestureDetector(
                                onTap: () async {
                                  print(isJoined);
                                  Get.to(
                                      ItemDetail(
                                        image: post['itemImg'],
                                        ownerName: post['ownerName'],
                                        ownerImage: post['ownerDp'],
                                        timestamp: post['timestamp'],
                                        itemName: post['itemName'],
                                        itemDescription: post["description"],
                                        itemPrice: post['charges'],
                                        backed: post['backed'],
                                        cost: post['cost'],
                                        currentbackers: post['currentbackers'],
                                        itempercent: itempercent.toString(),
                                        totalbackers: post['totalbackers'],
                                        category: post['category'],
                                        scope: post['scope'],
                                        selectedItemType:
                                            post['selectedItemType'],
                                        charges: post["charges"],
                                        isJoined: await isJoined,
                                        id: post['groupId'],
                                        userIdentifier:
                                            userIdentifier.toString(),
                                      ),
                                      transition: Transition.cupertinoDialog,
                                      duration: Duration(seconds: 1));
                                },
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: size.height * 0.4 + 80,
                                    maxHeight: size.height * 0.4 + 100,
                                  ),
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            0.3), // Adjust shadow color
                                        spreadRadius: 3, // Adjust spread
                                        blurRadius: 5, // Adjust blur
                                        offset: const Offset(0,
                                            3), // Adjust offset for direction
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        height: size.height * 0.2,
                                        width: size.width,
                                        child: CarouselSlider(
                                          options: CarouselOptions(
                                            autoPlay: true,
                                            aspectRatio: 2.0,
                                            enlargeCenterPage: true,
                                          ),
                                          items: (post['itemImg']
                                                  as List<dynamic>)
                                              .map((item) => Container(
                                                    child: Center(
                                                        child: Image.network(
                                                            item,
                                                            fit: BoxFit.cover,
                                                            width: 1000)),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                              color: KAppColors.kPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(30),
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
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(width: 30),
                                              Text(
                                                post['itemName'],
                                                style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(width: 30),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                child: Text(
                                                  post['description'],
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: KAppColors
                                                          .kDarkerGrey),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Row(
                                              children: [
                                                const SizedBox(width: 30),
                                                Text(
                                                  "• ",
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: KAppColors
                                                          .kDarkerGrey),
                                                ),
                                                Text(
                                                  post['category'],
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: KAppColors
                                                          .kDarkerGrey),
                                                ),
                                                Text(
                                                  " • ",
                                                  style: const TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: KAppColors
                                                          .kDarkerGrey),
                                                ),
                                                Text(
                                                  post['selectedItemType'],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: KAppColors
                                                          .kDarkerGrey),
                                                ),
                                                const Text(
                                                  " • ",
                                                  style:
                                                      TextStyle(fontSize: 22),
                                                ),
                                                Text(
                                                  post['scope'],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: KAppColors
                                                          .kDarkerGrey),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(children: [
                                            const SizedBox(width: 30),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              height: 30,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Raised',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5.0),
                                                    child: Text('Backers',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        )),
                                                  ),
                                                  Text('Goal',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ]),
                                          Row(children: [
                                            const SizedBox(width: 30),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              height: 30,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('${post['backed']} \$',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      )),
                                                  Text(
                                                    '${post['currentbackers'].toString()} out of ${post['totalbackers'].toString()}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  Text('${post['cost']} \$',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ]),
                                          Center(
                                            child: SizedBox(
                                              height: 5,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: LinearProgressIndicator(
                                                borderRadius:
                                                    BorderRadius.circular(45),
                                                color: Colors.deepPurple,
                                                value: double.parse(itempercent
                                                        .toString()) /
                                                    100,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Center(
                                            child: SizedBox(
                                              height: 21,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                      CupertinoIcons.gift),
                                                  const SizedBox(
                                                      width: 5, height: 5),
                                                  Text(
                                                      "${post['backed']}\$ Backed"),
                                                  Expanded(
                                                    child: Text(
                                                      "${(itempercent > 100 ? 100 : itempercent).toString()} %",
                                                      textAlign: TextAlign.end,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavm(index: 0),
          ),
        ],
      ),
    );
  }
/*---------------------------------------Functions-------------------------*/

  Future<List> getJoinedGroups(String userIdentifier) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userIdentifier)
          .get();
      final userData = userDoc.data();
      if (userData != null) {
        return userData['joinedGroups'] ?? [];
      } else {
        Get.snackbar(
          'User Data Error',
          'User data not found.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return [];
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to retrieve joined groups.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    }
  }

  Future<bool> isUserInGroup(String userIdentifier, String groupId) async {
    try {
      List<dynamic> joinedGroups = await getJoinedGroups(userIdentifier);
      return joinedGroups.contains(groupId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to check group membership.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> checkGroupMembership(String userId, String groupId) async {
    bool isMember = await isUserInGroup(userId, groupId);
    return isMember;
  }

  Future<void> joinGroup(String groupId, String userIdentifier) async {
    try {
      await GroupFunctions().addMemberToGroup(groupId, userIdentifier);
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userIdentifier)
          .update({
        'joinedGroups': FieldValue.arrayUnion([groupId]),
      });
      Get.snackbar('Success', 'Joined Successfully', colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error', 'Failed to join group', colorText: Colors.red);
    }
  }

  Future<void> updateData(int cost, String groupId, String postId, int amount,
      int backed, int currentbackers) async {
    try {
      int lastesbacked = backed + amount;
      double lastestpercent = lastesbacked / cost * 100;
      await FirebaseFirestore.instance.collection('Posts').doc(postId).update({
        'backed': lastesbacked.toString(),
        'currentbackers': (currentbackers + 1).toString(),
        'itemPercent': lastestpercent.toString(),
      });
      if (lastestpercent >= 100.0) {
        VotingService().initiateVoting(groupId);
      }
      Get.snackbar('Success', 'Data Updated Successfully',
          colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update data', colorText: Colors.red);
    }
  }

  Map<String, dynamic>? paymentIntentData;
  Future<void> initPaymentSheet(
      int cost,
      int amount,
      String groupId,
      String userIdentifier,
      String postId,
      int backed,
      int currentbackers) async {
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
      await displayPaymentSheet(cost, groupId, userIdentifier, postId, amount,
          backed, currentbackers);
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
      Get.snackbar('Error', 'Failed to initialize payment sheet',
          colorText: Colors.red);
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': (int.parse(amount) * 100).toString(), // Convert to cents
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
      throw Exception('Failed to create payment intent');
    }
  }

  Future<void> displayPaymentSheet(
      int cost,
      String groupId,
      String userIdentifier,
      String postId,
      int amount,
      int backed,
      int currentbackers) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      paymentIntentData = null;
      Get.snackbar('Success', 'Payment Successful', colorText: Colors.green);
      await joinGroup(groupId, userIdentifier);
      await updateData(cost, groupId, postId, amount, backed, currentbackers);
    } on StripeException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar('Error', 'Payment Canceled', colorText: Colors.red);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar('Error', 'Payment Failed', colorText: Colors.red);
    }
  }
}

import 'dart:convert';
import 'package:collab/extras/utils/Helper/groupchat/group.dart';
import 'package:collab/extras/utils/Helper/voting/voting_service.dart';
import 'package:collab/pages/home/item_detail.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/constant/navbarm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final FirestoreService fireStore = FirestoreService();
    final user = FirebaseAuth.instance.currentUser!;
    final userIdentifier = user.email ?? user.phoneNumber;

    return Scaffold(
      body: Container(
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
              return Stack(
                children: [
                  ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      var post = posts[index].data() as Map<String, dynamic>;
                      int itempercent = ((int.parse(post['backed'])) /
                              (int.parse(post['cost'])) *
                              100)
                          .toInt();
                      Future<bool> isJoined = isUserInGroup(
                          userIdentifier.toString(), post['groupId']) ;
                      // Future<bool> isMember =  checkGroupMembership(userIdentifier.toString(), post['groupId']);
                      return GestureDetector(
                        onTap: () async{
                          print(isJoined);
                          Get.to(ItemDetail(
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
                                selectedItemType: post['selectedItemType'],
                                charges: post["charges"],
                                isJoined: await isJoined,
                                id: post['groupId'],
                                userIdentifier: userIdentifier.toString()
                                ,
                              ));
                        },
                        child: Container(
                          height: size.height * 0.4 + 55,
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
                                            final postId =
                                                await getPostIdByGroupId(
                                                    groupId);

                                            try {
                                              List<dynamic> joinedGroups =
                                                  await getJoinedGroups(
                                                      userIdentifier!);
                                              if (!joinedGroups
                                                  .contains(groupId)) {
                                                initPaymentSheet(
                                                    int.parse(post['cost']),
                                                    int.parse(post['charges']),
                                                    groupId,
                                                    userIdentifier,
                                                    postId.toString(),
                                                    int.parse(post['backed']),
                                                    int.parse(post[
                                                        'currentbackers'])); // Pass the amount here
                                              } else {
                                                Get.snackbar(
                                                  'Already Joined',
                                                  'You have already joined this group.',
                                                );
                                              }
                                            } catch (e) {
                                              Get.snackbar(
                                                'Error',
                                                '$e',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
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
                                      Container(
                                        width: size.width - 100,
                                        child: Text(
                                          post['description'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: KAppColors.kDarkerGrey),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
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
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
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
                                          Text('${post['backed']} \$',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                              )),
                                          Text(
                                            '${post['currentbackers'].toString()} out of ${post['totalbackers'].toString()}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text('${post['cost']} \$',
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
                                        value: double.parse(itempercent.toString()) / 100,
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
        ),
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
Future<void> initPaymentSheet(int cost, int amount, String groupId,
    String userIdentifier, String postId, int backed, int currentbackers) async {
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
    await displayPaymentSheet(
      cost, groupId, userIdentifier, postId, amount, backed, currentbackers);
  } catch (e, s) {
    if (kDebugMode) {
      print(e);
      print(s);
    }
    Get.snackbar('Error', 'Failed to initialize payment sheet', colorText: Colors.red);
  }
}
Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
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
        'Authorization': 'Bearer sk_test_51PVutUDjz7PH5EWf1cU6vWF8c0g2xIvYEXNwE4TdtIeVIOZRvbYJMXLNXMwfRHUWKaVDjiQrs0kuY9r5DYaASb0Y00rTgcQHZj',
        'Content-Type': 'application/x-www-form-urlencoded'
      }
    );

    return jsonDecode(response.body);
  } catch (err) {
    if (kDebugMode) {
      print(err.toString());
    }
    throw Exception('Failed to create payment intent');
  }
}
Future<void> displayPaymentSheet(int cost, String groupId, String userIdentifier,
    String postId, int amount, int backed, int currentbackers) async {
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

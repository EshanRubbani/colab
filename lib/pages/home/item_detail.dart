import 'dart:convert';
import 'package:Collab/extras/utils/Helper/firestore.dart';
import 'package:Collab/extras/utils/Helper/groupchat/group.dart';
import 'package:Collab/extras/utils/Helper/voting/voting_service.dart';
import 'package:Collab/pages/authentication/views/login_or_signup_view/login_or_signup_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/pages/chatpage/group_chat_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ItemDetail extends StatefulWidget {
 List<dynamic> image;
  final String ownerName;
  final String ownerImage;
  final Timestamp timestamp;
  final String itemName;
  final String itemDescription;
  final String itemPrice;
  final String backed;
  final String currentbackers;
  final String totalbackers;
  final String cost;
  final String itempercent;
  final String category;
  final String scope;
  final String selectedItemType;
  final String charges;
  final bool isJoined;
  final String id;
  final String userIdentifier;

   ItemDetail({
    Key? key,
    required this.image,
    required this.ownerName,
    required this.ownerImage,
    required this.timestamp,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.backed,
    required this.currentbackers,
    required this.totalbackers,
    required this.cost,
    required this.itempercent,
    required this.category,
    required this.scope,
    required this.selectedItemType,
    required this.charges,
    required this.isJoined,
    required this.id,
    required this.userIdentifier,
  }) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    // Convert Timestamp to DateTime
    DateTime dateTime = widget.timestamp.toDate();
    // Format DateTime to only include year, month, and day
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Container(
                height: size.height / 3.5,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                                height: size.height * 0.2,
                                width: size.width,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    aspectRatio: 2.0,
                                    enlargeCenterPage: true,
                                    pauseAutoPlayOnTouch: true,

                                  ),
                                  items: (widget.image as List<dynamic>)
                                      .map((item) => Container(
                                            child: Center(
                                                child: Image.network(item,
                                                    fit: BoxFit.cover,
                                                    width: 1000)),
                                          ))
                                      .toList(),
                                ),
                              ),
                ),
              ),
              Container(
                height: 40,
                width: size.width,
                child: Row(
                  children: [
                    const SizedBox(width: 25),
                    Container(
                      width: 35,
                      child: CircleAvatar(
                        foregroundImage: NetworkImage(widget.ownerImage),
                        radius: 25,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      color: Colors.transparent,
                      width: 260,
                      child: Text(
                        widget.ownerName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Icon(Icons.calendar_month),
                    Container(
                      width: 100,
                      child: Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey.shade200,
                thickness: 1,
              ),
              Container(

  constraints: BoxConstraints(
    maxHeight: size.height / 2.9 + 10,
    minHeight: size.height / 2.9 - 120,
  ),
  width: size.width,
  child: IntrinsicHeight(
    child: Column(
      children: [
        Container(
          height: 50,
          width: size.width,
          child: Row(
            children: [
              const SizedBox(width: 20),
              Text(
                widget.itemName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                width: 150,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      KAppColors.kPrimary,
                    ),
                  ),
                  onPressed: () async {
                    if(widget.userIdentifier == ""){
                                              Get.to(()=>const LoginOrSignupScreen(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
                    }else{
                      if (widget.isJoined) {
                                                 Get.to(()=> GroupChatpage(
                        chatID: widget.id,
                        chatName: widget.itemName,
                      ),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
                      
                    } else {
                      final postId = await getPostIdByGroupId(widget.id);
                      try {
                        initPaymentSheet(
                          int.parse(widget.cost),
                          int.parse(widget.charges),
                          widget.id,
                          widget.userIdentifier,
                          postId.toString(),
                          int.parse(widget.backed),
                          int.parse(widget.currentbackers),
                        ); // Pass the amount here
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          '$e',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    }
                    }
                  },
                  child: Text(
                    widget.userIdentifier == "" ? "Login": widget.isJoined
                        ? "Open Group"
                        : 'Join ${widget.charges} \$',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(25),
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxHeight: size.height / 5 - 50,
                    minHeight: size.height / 5 - 180,
                  ),
                  width: size.width,
                  child: SingleChildScrollView(
                    child: Text(
                      widget.itemDescription,
                     
                      
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 30),
                    Container(
                      width: 400,
                      height: 30,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Raised',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 5.0),
                            child: Text(
                              'Backers',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            'Goal',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 30),
                    Container(
                      width: 400,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.backed} \$',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${widget.currentbackers} out of ${widget.totalbackers}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${widget.cost} \$',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: SizedBox(
                    height: 5,
                    width: 400,
                    child: LinearProgressIndicator(
                      color: Colors.deepPurple,
                      value: double.parse(widget.itempercent) / 100,
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
                        Text(
                          "${widget.backed}\$ Backed",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${widget.itempercent} \%",
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
),

              Divider(
                color: Colors.grey.shade200,
                thickness: 1,
              ),
              Container(
               
                height: size.height *0.4-215,
                width: size.width,
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Text("Category",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Poppins',color: Colors.black ),),
                        
                        Spacer(),
                        Text(widget.category,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Poppins',color: Colors.black ),),
                        SizedBox(width: 20,)
                      
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Text("Post Type",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Poppins',color: Colors.black ),),
                        
                        Spacer(),
                        Text(widget.selectedItemType,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Poppins',color: Colors.black ),),
                        SizedBox(width: 20,)
                      
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Text("Scope",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Poppins',color: Colors.black ),),
                        
                        Spacer(),
                        Text(widget.scope,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Poppins',color: Colors.black ),),
                        SizedBox(width: 20,)
                      
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Text("Charges",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Poppins',color: Colors.black ),),
                        
                        Spacer(),
                        Text("${widget.charges} \$",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Poppins',color: Colors.black ),),
                        SizedBox(width: 20,)
                      
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Text("Cost",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Poppins',color: Colors.black ),),
                        
                        Spacer(),
                        Text("${widget.cost} \$",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Poppins',color: Colors.black ),),
                        SizedBox(width: 20,)
                      
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
/*-------------------------------------------Functions----------------------------*/

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

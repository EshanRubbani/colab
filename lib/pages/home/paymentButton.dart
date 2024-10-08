// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:collab/extras/utils/Helper/groupchat/group.dart';
// import 'package:collab/extras/utils/constant/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// // import 'package:webview_all/webview_all.dart';
// import 'dart:convert';
// // import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'dart:html' as html;



// class PaymentButton extends StatelessWidget {
//   final String userIdentifier;
//   final Map<String, dynamic> post;
//   final String amount;


//   PaymentButton({required this.userIdentifier, required this.post, required this.amount});

//   Future<String> createPaymentIntent() async {
//     final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
//     final response = await http.post(
//       url,
//       headers: {
//         'Authorization': 'Bearer sk_test_51PVutUDjz7PH5EWf1cU6vWF8c0g2xIvYEXNwE4TdtIeVIOZRvbYJMXLNXMwfRHUWKaVDjiQrs0kuY9r5DYaASb0Y00rTgcQHZj', // Replace with your actual secret key
//         'Content-Type': 'application/x-www-form-urlencoded',
//       },
//       body: {
//         'amount': (int.parse(amount) * 100).toString(), // Replace with your actual amount
//         'currency': 'usd', // Replace with your actual currency
//       },
//     );

//     final responseBody = json.decode(response.body);
//     return responseBody['client_secret'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () async {
//         final groupId = post['groupId'];

//         final userDoc = await FirebaseFirestore.instance
//             .collection('Users')
//             .doc(userIdentifier)
//             .get();
//         final userData = userDoc.data();

//         if (userData != null) {
//           List<dynamic> joinedGroups = userData['joinedGroups'] ?? [];

//           if (!joinedGroups.contains(groupId)) {
//             // User has not joined the group yet, proceed to join
//             final clientSecret = await createPaymentIntent();

//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: Text("STRIPE PAYMENT",),
//                   // content: Webview(
//                   //   url: 'http://localhost:46655/web/stripe/stripe_webview.html?client_secret=$clientSecret',
                    

//                   // ),
//                   content: InAppWebView(
//                     initialUrlRequest: URLRequest(
//                       url: WebUri('https://collab-3e621.web.app/stripe/stripe_webview.html?client_secret=$clientSecret')
                      
//                     ),
//                       onWebViewCreated: (controller) {
//               // Listen for messages from the web view
//               html.window.onMessage.listen((event) async {
//                 if (event.data == 'paymentSuccess') {
//                   Navigator.of(context).pop(); // Close the dialog
//                   Get.snackbar('Success',
//                      'Payment Successful, You Have been Successfully Added to the Group',
//                   colorText: Colors.green);
//                     await joinGroup(groupId, userIdentifier);

//                 }
//               });
//             },
//                   ),
//                 );
//               },
//             );
//           } else {
//             // User already joined the group
//             Get.snackbar(
//               'Info',
//               'You are already a member of this group',
//               colorText: Colors.blue,
//             );
//           }
//         }
//       },
//       icon: Icon(Icons.ios_share),
//       color: KAppColors.kPrimary,
//     );
//   }
// }

// Future<void> joinGroup(groupId, String? userIdentifier) async {
//   GroupFunctions().addMemberToGroup(
//     groupId,
//     userIdentifier.toString(),
//   );

//   // Update Firestore with the new group in joinedGroups
//   await FirebaseFirestore.instance
//       .collection('Users')
//       .doc(userIdentifier)
//       .update({
//     'joinedGroups': FieldValue.arrayUnion([groupId]),
//   });

//   Get.snackbar('Success', 'Joined Successfully', colorText: Colors.green);
// }
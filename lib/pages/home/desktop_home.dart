import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/constant/navbarm.dart';
import 'package:collab/pages/chatpage/chatpage.dart';
import 'package:collab/pages/chatpage/group_chat_page.dart';
import 'package:collab/pages/chatselection/widgets/menu_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class DesktopHome extends StatefulWidget {
  const DesktopHome({ Key? key }) : super(key: key);

  @override
  _DesktopHomeState createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> {
 
@override
Widget build (BuildContext context) {
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
/*---------------------------------------Functions-------------------------*/

}

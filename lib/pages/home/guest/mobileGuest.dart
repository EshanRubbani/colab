import 'package:Collab/pages/authentication/views/login_or_signup_view/login_or_signup_screen.dart';
import 'package:Collab/pages/home/item_detail.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:Collab/extras/utils/constant/colors.dart';

class MobileGuest extends StatefulWidget {
  const MobileGuest({Key? key}) : super(key: key);

  @override
  _MobileGuestState createState() => _MobileGuestState();
}

class _MobileGuestState extends State<MobileGuest> {
  // Get posts stream
  Stream<QuerySnapshot> getPostsStream() {
    CollectionReference _postsCollection = FirebaseFirestore.instance.collection('Posts');
    return _postsCollection.orderBy('timestamp', descending: true).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: getPostsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No posts available'));
            } else {
              var posts = snapshot.data!.docs;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  var post = posts[index].data() as Map<String, dynamic>;
                  int itempercent = ((int.parse(post['backed'])) /
                          (int.parse(post['cost'])) *
                          100)
                      .toInt();
                  List<dynamic> imageList = post['itemImg'];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => ItemDetail(
                            image: post["itemImg"],
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
                            isJoined: false,
                            id: post['groupId'],
                            userIdentifier: ""
                          ),
                          transition: Transition.cupertinoDialog,
                          duration: Duration(seconds: 1));
                    },
                    child: Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: size.height * 0.2,
                            width: size.width,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                aspectRatio: 2.0,
                                enlargeCenterPage: true,
                              ),
                              items: (post['itemImg'] as List<dynamic>)
                                  .map((item) => Container(
                                        child: Center(
                                            child: Image.network(item,
                                                fit: BoxFit.cover,
                                                width: 1000)),
                                      ))
                                  .toList(),
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post['ownerName'],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          post['selectedItemType'],
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          post['scope'],
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post['itemName'],
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  post['category'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: KAppColors.kDarkerGrey),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  post['description'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: KAppColors.kDarkerGrey),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Raised',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        )),
                                    Text('Backers',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        )),
                                    Text('Goal',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        )),
                                  ],
                                ),
                                Row(
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
                                const SizedBox(height: 5),
                                SizedBox(
                                  height: 5,
                                  child: LinearProgressIndicator(
                                    color: Colors.deepPurple,
                                    value: double.parse(itempercent.toString()) / 100,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(CupertinoIcons.gift),
                                        const SizedBox(width: 5),
                                        Text("${post['backed']}\$ Backed"),
                                      ],
                                    ),
                                    Text(
                                      "${itempercent.toString()} \%",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

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
              );
            }
          },
        ),
      ),
    );
  }
}

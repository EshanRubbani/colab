import 'package:Collab/pages/authentication/views/login_or_signup_view/login_or_signup_screen.dart';
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

                  return GestureDetector(
                    onTap: () {
                      Get.to(LoginOrSignupScreen());
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
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.ios_share),
                                    color: KAppColors.kPrimary,
                                  ),
                                ),
                                Positioned(
                                  right: 20,
                                  bottom: 10,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.favorite_border_outlined),
                                    color: KAppColors.kPrimary,
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
              );
            }
          },
        ),
      ),
    );
  }
}

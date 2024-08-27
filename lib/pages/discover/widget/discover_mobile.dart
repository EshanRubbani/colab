import 'package:Collab/pages/home/item_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:Collab/extras/utils/Helper/all_post_model.dart';
import 'package:Collab/extras/utils/Helper/firestore.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/extras/utils/constant/navbarm.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class DiscoverMobile extends StatefulWidget {
  const DiscoverMobile({Key? key}) : super(key: key);

  @override
  _DiscoverMobileState createState() => _DiscoverMobileState();
}

class _DiscoverMobileState extends State<DiscoverMobile> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String selectedFilter = 'All';
  List<Item> allItems = [];
  List<Item> filteredItems = [];
  final FirestoreService fireStore = FirestoreService();

  Future<void> _handleresfresh() async {
    return await Future.delayed(Duration(seconds: 2));
  }

  void applyFilters(String filter) {
    setState(() {
      selectedFilter = filter;
      filteredItems = allItems.where((item) {
        bool matchesFilter = filter == 'All' ||
            (filter == 'Nearby' && int.parse(item.backed) > 0) ||
            (filter == 'Trending' && int.parse(item.itemPercent) > 68) ||
            (filter == '50\$+' && int.parse(item.backed) > 50);
        bool matchesSearch = item.itemName
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
        return matchesFilter && matchesSearch;
      }).toList();
    });
  }

  void fetchItems() {
    fireStore.getPostsStream().listen((snapshot) {
      List<Item> items = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        // Ensure itemImg is always treated as List<String>
        List<String> itemImg = [];
        if (data['itemImg'] is List<dynamic>) {
          itemImg =
              List<String>.from(data['itemImg']); // Convert to List<String>
        } else if (data['itemImg'] is String) {
          itemImg = [data['itemImg']]; // Wrap single string in a list
        }

        return Item(
          itemName: data['itemName'],
          ownerName: data['ownerName'],
          backed: data['backed'].toString(),
          itemPercent: data['itemPercent'].toString(),
          itemImg: itemImg,
          ownerDp: data['ownerDp'],
          selectedItemType: data['selectedItemType'],
          category: data['category'],
          charges: data['charges'],
          description: data['description'],
          cost: data['cost'],
          groupId: data['groupId'],
          timestamp: data['timestamp'],
          totalBackers: data['totalBackers'].toString(),
          scope: data['scope'],
          currentBackers: data['currentBackers'].toString(),
        );
      }).toList();

      setState(() {
        allItems = items;
        applyFilters(selectedFilter);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
    searchController.addListener(() {
      applyFilters(selectedFilter);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            height: 50,
            width: size.width,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: KAppColors.kPrimary),
                prefixIcon: Icon(
                  Icons.search,
                  color: KAppColors.kPrimary,
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: KAppColors.kPrimary,
                    width: 5,
                  ),
                ),
              ),
              onChanged: (value) => applyFilters(selectedFilter),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8, left: 25, right: 25),
            width: size.width,
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton("All", () => applyFilters("All")),
                  SizedBox(
                    width: 10,
                  ),
                  _buildFilterButton("Nearby", () => applyFilters("Nearby")),
                  SizedBox(
                    width: 10,
                  ),
                  _buildFilterButton(
                      "Trending", () => applyFilters("Trending")),
                  SizedBox(
                    width: 10,
                  ),
                  _buildFilterButton(
                      "Near to Full", () => applyFilters("Near to Full")),
                  SizedBox(
                    width: 10,
                  ),
                  _buildFilterButton("50\$+", () => applyFilters("50\$+")),
                ],
              ),
            ),
          ),
          Container(
            width: size.width,
            height: size.height - 245,
            child: LiquidPullToRefresh(
              onRefresh: _handleresfresh,
              backgroundColor: Colors.white,
              color: KAppColors.kPrimary,
              height: 300,
              showChildOpacityTransition: false,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return _buildItemCard(filteredItems[index], size);
                },
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavm(index: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, VoidCallback onPressed) {
    return TextButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(
            BorderSide(color: KAppColors.kPrimary, width: 2)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: KAppColors.kPrimary),
      ),
    );
  }

  Widget _buildItemCard(Item item, Size size) {
    final user = FirebaseAuth.instance.currentUser!;
    final userIdentifier = user.email ?? user.phoneNumber;
    Future<bool> isJoined =
        isUserInGroup(userIdentifier.toString(), item.groupId);
    return GestureDetector(
      onTap: () async {
        print(isJoined);
        Get.to(
            ItemDetail(
              image: item.itemImg,
              ownerName: item.ownerName,
              ownerImage: item.ownerDp,
              timestamp: item.timestamp,
              itemName: item.itemName,
              itemDescription: item.description,
              itemPrice: item.charges,
              backed: item.backed,
              cost: item.cost,
              currentbackers: item.currentBackers,
              itempercent: item.itemPercent,
              totalbackers: item.totalBackers,
              category: item.category,
              scope: item.scope,
              selectedItemType: item.selectedItemType,
              charges: item.charges,
              isJoined: await isJoined,
              id: item.groupId,
              userIdentifier: userIdentifier.toString(),
            ),
            transition: Transition.cupertinoDialog,
            duration: Duration(seconds: 1));
      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: size.height * 0.4 + 80,
          maxHeight: size.height * 0.4 + 110,
        ),
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
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
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              height: size.height * 0.2,
              width: size.width,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                ),
                items: item.itemImg
                    .map((imageUrl) => Container(
                          child: Center(
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: 1000,
                            ),
                          ),
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
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: KAppColors.kPrimary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Image.network(
                      item.ownerDp,
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  item.ownerName,
                  style: const TextStyle(fontSize: 16),
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
                      item.itemName,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 30),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        item.description,
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
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    children: [
                      const SizedBox(width: 30),
                      Text(
                        "• ",
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: KAppColors.kDarkerGrey),
                      ),
                      Text(
                        item.category,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: KAppColors.kDarkerGrey),
                      ),
                      Text(
                        " • ",
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: KAppColors.kDarkerGrey),
                      ),
                      Text(
                        item.selectedItemType,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: KAppColors.kDarkerGrey),
                      ),
                      const Text(
                        " • ",
                        style: TextStyle(fontSize: 22),
                      ),
                      Text(
                        item.scope,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: KAppColors.kDarkerGrey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  const SizedBox(width: 30),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Raised',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                            )),
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
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item.backed} \$',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                            )),
                        Text('${item.cost} \$',
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
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: LinearProgressIndicator(
                      color: Colors.deepPurple,
                      value: double.parse(item.itemPercent.toString()) / 100,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    height: 21,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.gift),
                        const SizedBox(width: 5, height: 5),
                        Text("${item.backed}\$ Backed"),
                        Expanded(
                          child: Text(
                            "${(double.parse(item.itemPercent) > 100 ? 100 : item.itemPercent).toString()} %",
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
  }
}

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

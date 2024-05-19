// ignore_for_file: sized_box_for_whitespace, unused_local_variable
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/Helper/homeitems.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/constant/navbar.dart';
import 'package:collab/extras/utils/constant/navbarm.dart';
import 'package:collab/extras/utils/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String selectedFilter = 'All';
  List<Item> filteredItems = [];
  final FireStore fireStore = FireStore();
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        applyFilter('All');
      } else {
        applyFilter(selectedFilter);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      filteredItems = filteredItems.where((item) {
        bool matchesFilter = filter == 'All' ||
            (filter == 'Nearby' && item.backed > 0) ||
            (filter == 'Trending' && item.itemPercent > 75) ||
            (filter == '50\$+' && item.backed > 50);
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
        return Item(
          itemName: data['itemName'],
          ownerName: data['ownerName'],
          backed: data['backed'],
          itemPercent: data['itemPercent'],
          itemImg: data['itemImg'],
          ownerDp: data['ownerDp'],
        );
      }).toList();

      setState(() {
        filteredItems = items;
        applyFilter(selectedFilter);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: const [],
      ),
      body: ResponsiveNess(
        mobile: _buildForMobile(size),
        desktop: _buildForDesktop(),
      ),
    );
  }

  Widget _buildForDesktop() {
    return const Column();
  }

  Widget _buildForMobile(Size size) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Container(
            height: 50,
            width: size.width,
            child: SearchBar(
              controller: searchController,
              constraints: BoxConstraints(maxHeight: 60, maxWidth: size.width),
              hintText: 'Search',
              elevation: MaterialStateProperty.all(0),
              surfaceTintColor: MaterialStateProperty.all<Color>(Colors.white),
              leading: const Icon(
                CupertinoIcons.circle,
                size: 20,
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              side: MaterialStateProperty.all(
                  BorderSide(color: Colors.grey.shade300, width: 2)),
              textStyle: MaterialStateProperty.all(
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Container(
          width: size.width,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 35, right: 35),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton('All'),
                  const SizedBox(width: 12),
                  _buildFilterButton('Nearby'),
                  const SizedBox(width: 12),
                  _buildFilterButton('Trending'),
                  const SizedBox(width: 12),
                  _buildFilterButton('Near to full'),
                  const SizedBox(width: 12),
                  _buildFilterButton('50\$+'),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<void>(
            future: Future.value(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Stack(
                  children: [
                    ListView.builder(
                      controller: _scrollController,
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return _buildItemCard(filteredItems[index], size);
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 5),
                        height: _isVisible ? 130 : 0,
                        child: _isVisible ? const BottomNavm(index: 1) : null,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  TextButton _buildFilterButton(String filter) {
    return TextButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(
            BorderSide(color: Colors.grey.shade300, width: 2)),
      ),
      onPressed: () {
        setState(() {
          applyFilter(filter);
        });
      },
      child: Text(
        filter,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildItemCard(Item item, Size size) {
    return Container(
      height: size.height * 0.4,
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
                image: NetworkImage(item.itemImg),
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
                      onPressed: () {},
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
                      icon: const Icon(Icons.favorite_border_outlined),
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
                    item.ownerDp,
                    width: 20,
                    height: 20,
                    fit: BoxFit.fill,
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
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.itemName,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 30),
              Container(
                height: 3.48,
                width: 358,
                child: Center(
                  child: LinearProgressIndicator(
                    color: Colors.deepPurple,
                    value: item.itemPercent / 100,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 21,
                width: 358.18,
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.gift),
                    const SizedBox(width: 5),
                    Text("${item.backed}\$ Backed"),
                    Expanded(
                      child: Text(
                        "${item.itemPercent}%",
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

_buildForDesktop(size) {
  return Scaffold(
    body: Stack(
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  constraints: BoxConstraints(
                      maxHeight: size.height * 0.7,
                      minHeight: size.height * 0.5),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 0.1,
                        offset:
                            const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/home/piano.jpg'),
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
                                  onPressed: () {},
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
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
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
                              child: Image.asset(
                                'assets/icons/google.png',
                                width: 20,
                                height: 20,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Olivia Hez',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          const Text(
                            'Vintage Piano',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 3.48,
                            width: 300,
                            child: const Center(
                              child: LinearProgressIndicator(
                                color: Colors.deepPurple,
                                value: 0.7,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 21,
                            width: 300,
                            child: const Row(
                              children: [
                                Icon(CupertinoIcons.gift),
                                SizedBox(
                                  width: 5,
                                  height: 5,
                                ),
                                Text("150\$ Backed"),
                                Expanded(
                                  child: Text(
                                    "70%",
                                    textAlign: TextAlign.end,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
        ),
        //custom floating dock
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 400,
            child: const BottomNav(index: 1),
          ),
        )
      ],
    ),
  );
}

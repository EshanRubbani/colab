import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:collab/extras/utils/Helper/all_post_model.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/constant/navbarm.dart';

class DiscoverDesktop extends StatefulWidget {
  const DiscoverDesktop({super.key});

  @override
  _DiscoverDesktopState createState() => _DiscoverDesktopState();
}

class _DiscoverDesktopState extends State<DiscoverDesktop> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String selectedFilter = 'All';
  List<Item> allItems = [];
  List<Item> filteredItems = [];
  final FirestoreService fireStore = FirestoreService();

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
          selectedItemType: data['selectedItemType'],
        );
      }).toList();

      setState(() {
        allItems = items;
        applyFilters(selectedFilter);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
                      
                      maxWidth: 500,
                      minWidth: 360,
                    ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only( left: 20,right: 20),
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 50,
                    minHeight: 50,
                    maxWidth: 500,
                    minWidth: 360,
                  ),
                  
                  child: SearchBar(
                    controller: searchController,
                    constraints: BoxConstraints(maxHeight: 60, maxWidth: size.width),
                    hintText: 'Search',
                    elevation: WidgetStateProperty.all(0),
                    surfaceTintColor: WidgetStateProperty.all(Colors.white),
                    leading: const Icon(
                      CupertinoIcons.circle,
                      size: 20,
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    side: WidgetStateProperty.all(
                        BorderSide(color: Colors.grey.shade300, width: 2)),
                    textStyle: WidgetStateProperty.all(
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
               
           
              Padding(
            padding: const EdgeInsets.only(top: 8, left: 35, right: 35, bottom:  8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TextButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                        BorderSide(color: Colors.grey.shade300, width: 2)),
                  ),
                  onPressed: () {
                    applyFilters("All");
                  },
                  child: const Text(
                    "All",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                  const SizedBox(width: 12),
                  TextButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                        BorderSide(color: Colors.grey.shade300, width: 2)),
                  ),
                  onPressed: () {
                    applyFilters("Nearby");
                  },
                  child: const Text(
                    "Nearby",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                  const SizedBox(width: 12),
                 TextButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                        BorderSide(color: Colors.grey.shade300, width: 2)),
                  ),
                  onPressed: () {
                    applyFilters("Trending");
                  },
                  child: const Text(
                    "Trending",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                  const SizedBox(width: 12),
                  TextButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                        BorderSide(color: Colors.grey.shade300, width: 2)),
                  ),
                  onPressed: () {
                    applyFilters("Near to Full");
                  },
                  child: const Text(
                    "Near to Full",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                  const SizedBox(width: 12),
                 TextButton(
                  style: ButtonStyle(
                    side: WidgetStateProperty.all(
                        BorderSide(color: Colors.grey.shade300, width: 2)),
                  ),
                  onPressed: () {
                    applyFilters("50\$+");
                  },
                  child: const Text(
                    "50\$+",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ],
              ),
            ),
          ),
         
              Expanded(
                child: StreamBuilder<void>(
                  stream: fireStore.getPostsStream(),
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
                            
                              width: 400,
                              child: const BottomNavm(index: 1),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(Item item, Size size) {
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
            offset: const Offset(0, 2),
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
              const Text(
                                 "  ",
                                  style: TextStyle(fontSize: 22),
                                ),
                                Text(
                                  item.selectedItemType,
                                  style: const TextStyle(fontSize: 10,color: Colors.grey  ),
                                ),
            ],
          ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const SizedBox(width: 60,),
                  Text(
                    item.itemName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800,),
                    
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 3.48,
                width: 340,
                child: LinearProgressIndicator(
                  color: Colors.deepPurple,
                  value: int.parse(item.itemPercent) / 100,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 21,
                width: 340,
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

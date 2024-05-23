import 'package:collab/extras/utils/Helper/all_post_model.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/constant/navbarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
 

    void applyFilters(String filter) {
      setState(() {
        selectedFilter = filter;
        filteredItems = allItems.where((item) {
          bool matchesFilter = filter == 'All' ||
              (filter == 'Nearby' && item.backed > 0) ||
              (filter == 'Trending' && item.itemPercent > 68) ||
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
              elevation: WidgetStateProperty.all(0),
              surfaceTintColor: WidgetStateProperty.all<Color>(Colors.white),
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
        Container(
          width: size.width,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 35, right: 35),
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
                        height: 130,
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
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
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

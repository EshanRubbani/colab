import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:Collab/extras/utils/Helper/all_post_model.dart';
import 'package:Collab/extras/utils/Helper/firestore.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/extras/utils/constant/navbarm.dart';
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


  Future<void> _handleresfresh()async{
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
          itemImg = List<String>.from(data['itemImg']); // Convert to List<String>
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
          charges:  data['charges'],
          description: data['description'],
          cost: data['cost'],
        
          groupId: data['groupId'],
          timestamp: data['timestamp'].toString(),
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: SizedBox(
            height: 50,
            width: size.width,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) => applyFilters(selectedFilter),
            ),
          ),
        ),
        SizedBox(
          width: size.width,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 35, right: 35),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton("All", () => applyFilters("All")),
                  _buildFilterButton("Nearby", () => applyFilters("Nearby")),
                  _buildFilterButton("Trending", () => applyFilters("Trending")),
                  _buildFilterButton("Near to Full", () => applyFilters("Near to Full")),
                  _buildFilterButton("50\$+", () => applyFilters("50\$+")),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              LiquidPullToRefresh(
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
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 5),
                  height: 130,
                  child: const BottomNavm(index: 1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String text, VoidCallback onPressed) {
    return TextButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(BorderSide(color: Colors.grey.shade300, width: 2)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildItemCard(Item item, Size size) {
    return Container(
      height: size.height * 0.4 +30,
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
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
              items: item.itemImg.map((imageUrl) => Container(
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 1000,
                  ),
                ),
              )).toList(),
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
                                        fit: BoxFit.cover,
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
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.grey),
                                  ),
                                  const Text(
                                    "  ",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  Text(
                                   item.scope,
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
                                        item.itemName,
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
                                        item.category,
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
                                      width: 400,
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
                                      width: 400,
                                      child: Row(
                                        children: [
                                          const Icon(CupertinoIcons.gift),
                                          const SizedBox(width: 5, height: 5),
                                          Text("${item.backed}\$ Backed"),
                                          Expanded(
                                            child: Text(
                                              "${item.itemPercent.toString()} \%",
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
    );
  }
}

import 'package:collab/models/homeitems.dart';
import 'package:collab/utils/constant/colors.dart';
import 'package:collab/utils/navbar.dart';
import 'package:collab/utils/navbarm.dart';
import 'package:collab/utils/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DiscoverScreen extends StatefulWidget {
  DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String selectedFilter = 'All'; // Initial filter is 'All'
  List<Item> filteredItems = [];
  FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    firebaseService.initialize().then((_) {
      setState(() {
        filteredItems = firebaseService.items; // Initialize with all items
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
        mobile: _buildForMobile(),
        desktop: _buildForDesktop(),
      ),
    );
  }

  _buildForMobile() {
    final size = MediaQuery.of(context).size;
    final searchController = TextEditingController();

    void applyFilter(String filter) {
      setState(() {
        selectedFilter = filter;
        filteredItems = filter == 'All'
            ? firebaseService.items
            : firebaseService.items.where((item) {
                // Implement filtering logic for 'Nearby,' 'Trending,' etc. here
                if (filter == 'Nearby') {
                  // Filter logic for 'Nearby' items (e.g., based on location)
                  return item.backed > 0; // Replace with your actual logic
                } else if (filter == 'Trending') {
                  // Filter logic for 'Trending' items
                  return item.itemPercent >
                      75; // Example: Trending if progress > 75%
                } else if (filter == '50 \$ +') {
                  // Filter logic for '50$+' items
                  return item.backed > 50;
                } else {
                  return false;
                }
              }).toList();
      });
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22, right: 22),
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
                  borderRadius: BorderRadius.circular(
                      8), // Set borderRadius to zero for a rectangle
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
          // color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 35, right: 35),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TextButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          BorderSide(color: Colors.grey.shade300, width: 2)),
                    ),
                    onPressed: () {
                      applyFilter('All');
                    },
                    child: const Text(
                      "All",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          BorderSide(color: Colors.grey.shade300, width: 2)),
                    ),
                    onPressed: () {
                      applyFilter('Nearby');
                    },
                    child: const Text(
                      "Nearby",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          BorderSide(color: Colors.grey.shade300, width: 2)),
                    ),
                    onPressed: () {
                      applyFilter('Trending');
                    },
                    child: const Text(
                      "Trending",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          BorderSide(color: Colors.grey.shade300, width: 2)),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Near to full",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                          BorderSide(color: Colors.grey.shade300, width: 2)),
                    ),
                    onPressed: () {
                      applyFilter('50\$+');
                    },
                    child: const Text(
                      "50\$+",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
        FutureBuilder<void>(
          future: Future.value(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator()); // Loading
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}')); // Error
            } else {
              return Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
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
                                offset: const Offset(
                                    0, 2), // changes position of shadow
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
                                    image: NetworkImage(
                                      filteredItems[index].itemImg,
                                    ),
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
                                        filteredItems[index].ownerDp,
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    filteredItems[index].ownerName,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredItems[index].itemName,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    height: 3.48,
                                    width: 358,
                                    child: Center(
                                      child: LinearProgressIndicator(
                                        color: Colors.deepPurple,
                                        value:
                                            filteredItems[index].itemPercent /
                                                100,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 21,
                                    width: 358.18,
                                    child: Row(
                                      children: [
                                        const Icon(CupertinoIcons.gift),
                                        const SizedBox(
                                          width: 5,
                                          height: 5,
                                        ),
                                        Text(
                                            "${filteredItems[index].backed}\$ Backed"),
                                        Expanded(
                                          child: Text(
                                            "${filteredItems[index].itemPercent}%",
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
                      },
                    ),
                    //custom floating dock
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: BottomNavm(index: 1),
                    )
                  ],
                ),
              );
            }
          },
        )
      ],
    );
  }

  _buildForDesktop() {
    final size = MediaQuery.of(context).size;
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
}

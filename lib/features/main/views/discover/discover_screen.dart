import 'package:collab/features/main/views/home/home_screen.dart';
import 'package:collab/utils/constant/colors.dart';
import 'package:collab/utils/device/device_size.dart';
import 'package:collab/utils/navbar.dart';
import 'package:collab/utils/navbarm.dart';
import 'package:collab/utils/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _searchController = TextEditingController();

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      autofocus: false,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [],
        ),
        body: ResponsiveNess(
          mobile: _buildForMobile(size),
          desktop: _buildForDesktop(size),
        ));
  }

  Widget _topbar() {
    return Container(
      height: 200,
      color: Colors.red,
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            autofocus: false,
            decoration: const InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
          )
        ],
      ),
    );
  }

  _buildForMobile(Size size) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 22, right: 22),
            child: Container(
              height: 50,
              width: size.width,
              child: SearchBar(
                constraints:
                    BoxConstraints(maxHeight: 60, maxWidth: size.width),
                hintText: 'Search',
                elevation: MaterialStateProperty.all(0),
                surfaceTintColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                leading: Icon(
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
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      onPressed: () {},
                      child: Text(
                        "Nearby",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            BorderSide(color: Colors.grey.shade300, width: 2)),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Trending",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            BorderSide(color: Colors.grey.shade300, width: 2)),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Near to full",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            BorderSide(color: Colors.grey.shade300, width: 2)),
                      ),
                      onPressed: () {},
                      child: Text(
                        "100k \$ +",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                    itemCount: 10,
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
                                  image: AssetImage(
                                      'assets/images/home/piano.jpg'),
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
                                  'Olivia Oscar',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Vintage Piano',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  height: 3.48,
                                  width: 358,
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
                                  width: 358.18,
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
                //custom floating dock
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomNavm(index: 1),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildForDesktop(Size size) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 500),
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
                            image: DecorationImage(
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
                            SizedBox(
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

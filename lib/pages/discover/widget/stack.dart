import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/constant/navbar.dart';

import 'package:collab/extras/utils/constant/navbarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Stackmobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
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
                      offset: const Offset(0, 2), // changes position of shadow
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
                                icon:
                                    const Icon(Icons.favorite_border_outlined),
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
                              fontSize: 22, fontWeight: FontWeight.w800),
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
    );
  }
}

class StackDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
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
    );
  }
}
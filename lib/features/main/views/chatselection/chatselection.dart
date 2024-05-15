import 'package:collab/features/main/views/home/home_screen.dart';
import 'package:collab/utils/constant/colors.dart';
import 'package:collab/utils/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChatSelectScreen extends StatefulWidget {
  const ChatSelectScreen({super.key});

  @override
  State<ChatSelectScreen> createState() => _ChatSelectScreenState();
}

class _ChatSelectScreenState extends State<ChatSelectScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 5,
          surfaceTintColor: Colors.white,
          shadowColor: KAppColors.kLightGrey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          backgroundColor: Colors.white,
          centerTitle: true,
          primary: true,
          title: const Text(
            "Chat",
            style: TextStyle(color: KAppColors.kPrimary),
          ),
          leading: IconButton(
            onPressed: () {
              Get.to(() => const HomeScreen());
            },
            icon: const Icon(
              CupertinoIcons.back,
              color: KAppColors.kPrimary,
            ),
          ),
        ),
        body: ResponsiveNess(
          mobile: _buildForMobile(size),
          desktop: _buildForDesktop(size),
        ));
  }
}

_buildForMobile(Size size) {
  return Scaffold(
    body: Stack(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 40, bottom: 10),
                  width: 360,
                  height: 56,
                  padding: const EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFCBD5E1),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: SizedBox(
                          child: TextField(
                            showCursor: false,
                            decoration: InputDecoration(
                                hintText: 'Select Users to Send Message',
                                border: InputBorder.none),
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0.09,
                            ),
                            enableInteractiveSelection: true,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: const Icon(CupertinoIcons.search),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  // color: Colors.grey.shade500,
                  width: 360,
                  height: size.height / 1.25,
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 325,
                        height: 80,
                        // color: Colors.black,
                        margin: const EdgeInsets.only(
                          top: 15,
                          left: 5,
                          right: 5,
                        ),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 0.2,
                              offset: const Offset(
                                  0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: const DecorationImage(
                                    image:
                                        AssetImage("assets/images/profile.png"),
                                    fit: BoxFit.cover),
                              ),
                              height: 60,
                              width: 60,
                              // color: Colors.black,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Container(
                              width: 170,
                              height: 60,
                              // color: Colors.black,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    // color: Colors.black,
                                    width: 170,
                                    height: 25,
                                    child: const Text(
                                      "Ahmed Jamal",
                                      style: TextStyle(
                                        fontFamily: "Inter",
                                        fontSize: 14,
                                        color: KAppColors.kPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 25,
                                    width: 170,
                                    // color: Colors.black,
                                    child: Text(
                                      "Roll Number",
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                                // decoration: BoxDecoration(shape: BoxShape.circle),
                                width: 34,
                                height: 34,
                                margin: const EdgeInsets.only(right: 20),
                                // color: Colors.black,
                                child: MyCheckboxWidget())
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Align(
                heightFactor: BorderSide.strokeAlignCenter,
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: const MyButton(index: true),
                ),
              ),
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
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 40, bottom: 10),
                  width: 360,
                  height: 56,
                  padding: const EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFCBD5E1),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: SizedBox(
                          child: TextField(
                            showCursor: false,
                            decoration: InputDecoration(
                                hintText: 'Select Users to Send Message',
                                border: InputBorder.none),
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0.09,
                            ),
                            enableInteractiveSelection: true,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: const Icon(CupertinoIcons.search),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  // color: Colors.grey.shade500,
                  width: 360,
                  height: size.height / 1.34,
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 325,
                        height: 80,
                        // color: Colors.black,
                        margin: const EdgeInsets.only(
                          top: 15,
                          left: 5,
                          right: 5,
                        ),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 0.2,
                              offset: const Offset(
                                  0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: const DecorationImage(
                                    image:
                                        AssetImage("assets/images/profile.png"),
                                    fit: BoxFit.cover),
                              ),
                              height: 60,
                              width: 60,
                              // color: Colors.black,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Container(
                              width: 170,
                              height: 60,
                              // color: Colors.black,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    // color: Colors.black,
                                    width: 170,
                                    height: 25,
                                    child: const Text(
                                      "Ahmed Jamal",
                                      style: TextStyle(
                                        fontFamily: "Inter",
                                        fontSize: 14,
                                        color: KAppColors.kPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 25,
                                    width: 170,
                                    // color: Colors.black,
                                    child: Text(
                                      "Roll Number",
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                                // decoration: BoxDecoration(shape: BoxShape.circle),
                                width: 34,
                                height: 34,
                                margin: const EdgeInsets.only(right: 20),
                                // color: Colors.black,
                                child: MyCheckboxWidget())
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Align(
                heightFactor: BorderSide.strokeAlignCenter,
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: const MyButton(index: true),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

menubar() {
  return Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade500)),
    height: 250,
    width: 360,
    child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              minimumSize: const Size(345, 55),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade500),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {},
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  //color: Colors.red,
                  child: Image.asset('assets/images/hat.png'),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "All Group Members",
                  style: TextStyle(color: KAppColors.kPrimary),
                ),
                const Spacer(),
                Container(
                    height: 20,
                    width: 20,
                    //color: Colors.red,
                    child: GestureDetector(
                      child: const Icon(CupertinoIcons.forward),
                      onTap: () {},
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              minimumSize: const Size(345, 55),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade500),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {},
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  //color: Colors.red,
                  child: Image.asset('assets/images/hat.png'),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Male",
                  style: TextStyle(color: KAppColors.kPrimary),
                ),
                const Spacer(),
                Container(
                    height: 20,
                    width: 20,
                    //color: Colors.red,
                    child: GestureDetector(
                      child: const Icon(CupertinoIcons.forward),
                      onTap: () {},
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              minimumSize: const Size(345, 55),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade500),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {},
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  //color: Colors.red,
                  child: Image.asset('assets/images/hat.png'),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Female",
                  style: TextStyle(color: KAppColors.kPrimary),
                ),
                const Spacer(),
                Container(
                    height: 20,
                    width: 20,
                    //color: Colors.red,
                    child: GestureDetector(
                      child: const Icon(CupertinoIcons.forward),
                      onTap: () {},
                    )),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class MyCheckboxWidget extends StatefulWidget {
  // Changed to StatefulWidget
  @override
  _MyCheckboxWidgetState createState() => _MyCheckboxWidgetState();
}

class _MyCheckboxWidgetState extends State<MyCheckboxWidget> {
  // Added state class
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      activeColor: Colors.green,
      shape: const CircleBorder(),
      value: isChecked,
      onChanged: (bool? newValue) {
        setState(() {
          // Now setState is available
          isChecked = newValue!;
        });
      },
    );
  }
}

class MyButton extends StatefulWidget {
  final bool index;

  const MyButton({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  bool showContainer = true;
  Widget build(BuildContext context) {
    return showContainer
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              fit: StackFit.passthrough,
              children: [
                Container(
                  //width: 380,
                  constraints:
                      const BoxConstraints(minWidth: 380.0, minHeight: 60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: KAppColors.kPrimary,
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.3), // Adjust shadow color
                        spreadRadius: 3, // Adjust spread
                        blurRadius: 5, // Adjust blur
                        offset:
                            const Offset(0, 3), // Adjust offset for direction
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(KAppColors.kPrimary),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Type Message",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Inter",
                        ),
                      )),
                )
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/pages/chatpage/chatpage.dart';
import 'package:collab/pages/chatselection/widgets/menu_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class ChatSelectionMobile extends StatefulWidget {
  const ChatSelectionMobile({super.key});

  @override
  _ChatSelectionMobileState createState() => _ChatSelectionMobileState();
}

class _ChatSelectionMobileState extends State<ChatSelectionMobile> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  List<DocumentSnapshot> selectedUsers = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreService fireStore = FirestoreService();
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 40, bottom: 10),
                      width: 400,
                      height: 56,
                      padding: const EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
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
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                return GestureDetector(
                                  onDoubleTap: () {
                                    showPopover(
                                      context: context,
                                      bodyBuilder: (context) => const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: MenuItem(),
                                      ),
                                      width: 360,
                                      height: 300,
                                      direction: PopoverDirection.bottom,
                                      arrowHeight: 0,
                                      arrowWidth: 0,
                                      backgroundColor: Colors.white,
                                    );
                                  },
                                  child: TextField(
                                    controller: searchController,
                                    showCursor: true,
                                    decoration: const InputDecoration(
                                      hintText: 'Select Users to Send Message',
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    enableInteractiveSelection: true,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: 400,
                      height: size.height / 1.25,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: fireStore.getUsersStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return const Center(child: Text('No users available'));
                          } else {
                            var users = snapshot.data!.docs;
                            var filteredUsers = users.where((userDoc) {
                              var user = userDoc.data() as Map<String, dynamic>;
                              var fullName = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.toLowerCase();
                              return fullName.contains(searchQuery.toLowerCase());
                            }).toList();

                            return ListView.builder(
                              itemCount: filteredUsers.length,
                              itemBuilder: (context, index) {
                                var user = filteredUsers[index].data() as Map<String, dynamic>;
                                bool isSelected = selectedUsers.contains(filteredUsers[index]);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => Chatpage(
                                        receiverEmail: user['email'],
                                        receiverID: user['userUID'],
                                        ),
                                    ));
                                  },
                                  child: _buildUserList(user, isSelected, filteredUsers[index]),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const Align(
                    heightFactor: BorderSide.strokeAlignCenter,
                    alignment: Alignment.bottomCenter,
                    child: MyButton(index: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(Map<String, dynamic> user, bool isSelected, DocumentSnapshot userDoc) {
   if(user["email"] != FirebaseAuth.instance.currentUser!.email){
     return Container(
      width: 400,
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? KAppColors.kPrimary : Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? KAppColors.kPrimary.withOpacity(0.1) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 0.2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                image: user['userIMG']?.isNotEmpty ?? false
                    ? NetworkImage(user['userIMG']) as ImageProvider
                    : const AssetImage('assets/images/profile.png'),
                fit: BoxFit.cover,
              ),
            ),
            height: 60,
            width: 60,
          ),
          const SizedBox(width: 15),
          SizedBox(
            width: 170,
            height: 60,
            child: Column(
              children: [
                const SizedBox(height: 5),
                SizedBox(
                  width: 170,
                  height: 25,
                  child: Text(
                    '${user['firstName'] ?? 'First Name'} ${user['lastName'] ?? 'Last Name'}',
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      color: KAppColors.kPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                  width: 170,
                  child: Text(
                    user['email'] ?? 'Email',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(right: 20),
            child: Checkbox(
              activeColor: Colors.green,
              shape: const CircleBorder(),
              value: isSelected,
              onChanged: (bool? newValue) {
                setState(() {
                  if (newValue == true) {
                    selectedUsers.add(userDoc);
                  } else {
                    selectedUsers.remove(userDoc);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
   }else{
     return Container();
   }
  }
}

class MyButton extends StatefulWidget {
  final bool index;

  const MyButton({
    super.key,
    required this.index,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool showContainer = true;

  @override
  Widget build(BuildContext context) {
    return showContainer
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  constraints: const BoxConstraints(minWidth: 380.0, minHeight: 60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: KAppColors.kPrimary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(KAppColors.kPrimary),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Type Message",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Inter",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

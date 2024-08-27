import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Collab/extras/utils/Helper/firestore.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/extras/utils/constant/navbarm.dart';
import 'package:Collab/pages/chatpage/chatpage.dart';
import 'package:Collab/pages/chatpage/group_chat_page.dart';
import 'package:Collab/pages/chatselection/widgets/menu_item.dart';
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
  FirestoreService firestoreService = FirestoreService();

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
    final Size size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser!;
    final userIdentifier = user.email ?? user.phoneNumber;

    return DefaultTabController(
      length: 2, // Two tabs
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Search Bar
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 100),
                      width: 400,
                      height: 56,
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 2,
                            color: KAppColors.kPrimary,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                                      hintStyle:
                                          TextStyle(color: KAppColors.kPrimary),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                      color: KAppColors.kPrimary,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
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
                  const SizedBox(
                    height: 10,
                  ),
                  // Tabs for Group Chats and Individual Chats
                  const TabBar(
                    labelColor: KAppColors.kPrimary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: KAppColors.kPrimary,
                    tabs: [
                      Tab(text: 'Group Chats'),
                      Tab(text: 'Individual Chats'),
                    ],
                  ),

                  // TabBarView to display content for each tab
                  SizedBox(
                    height: size.height * 0.8 - 80, // Set height for TabBarView
                    child: TabBarView(
                      children: [
                        // Group Chats
                        Container(
                          width: 400,
                          color: Colors.white,
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          child: SingleChildScrollView(
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: firestore
                                  .collection('Users')
                                  .doc(userIdentifier)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final data = snapshot.data?.data()
                                      as Map<String, dynamic>?;

                                  if (data == null) {
                                    return const Center(
                                        child: Text('No Group data found.'));
                                  }

                                  return buildGroupListView(data);
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        ),

                        // Individual Chats
                        Container(
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          child: SingleChildScrollView(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: firestoreService.getUsersStream(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return const Center(
                                      child: Text('No users available'));
                                } else {
                                  var users = snapshot.data!.docs;
                                  var filteredUsers = users.where((userDoc) {
                                    var user =
                                        userDoc.data() as Map<String, dynamic>;
                                    var fullName =
                                        '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'
                                            .toLowerCase();
                                    return fullName
                                        .contains(searchQuery.toLowerCase());
                                  }).toList();

                                  return Container(
                                    child: buildIndividualChatListView(
                                        filteredUsers),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // The fixed button at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavm(index: 3),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildIndividualChatListView(
      List<QueryDocumentSnapshot<Object?>> filteredUsers) {
    return ListView.builder(
      padding: EdgeInsets.zero, // Ensure no padding inside the ListView

      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        var user = filteredUsers[index].data() as Map<String, dynamic>;
        bool isSelected = selectedUsers.contains(filteredUsers[index]);
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
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

  ListView buildGroupListView(Map<String, dynamic> data) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data['joinedGroups']?.length ?? 0,
      itemBuilder: (context, index) {
        final groupId = data['joinedGroups'][index];
        return FutureBuilder<Map<String, dynamic>?>(
          future: firestoreService.fetchGroupDetails(groupId),
          builder: (context, groupSnapshot) {
            if (groupSnapshot.connectionState == ConnectionState.waiting) {
              return const ListTile(
                title: Text('Loading...'),
              );
            } else if (groupSnapshot.hasError) {
              return ListTile(
                title: Text('Error: ${groupSnapshot.error}'),
              );
            } else if (!groupSnapshot.hasData || groupSnapshot.data == null) {
              return const ListTile(
                title: Text('Group not found'),
              );
            } else {
              final groupDetails = groupSnapshot.data!;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupChatpage(
                        chatID: groupId,
                        chatName: groupDetails['groupName'],
                        isGroupChat: true,
                      ),
                    ),
                  );
                },
                child: _buildGroupList(groupDetails),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildUserList(
      Map<String, dynamic> user, bool isSelected, DocumentSnapshot userDoc) {
    final user1 = FirebaseAuth.instance.currentUser!;
    final userIdentifier = user1.email ?? user1.phoneNumber!;
    if (user["email"] != userIdentifier) {
      return Container(
        
        width: 400,
        height: 80,
        margin: const EdgeInsets.only(top: 15,left: 20,right: 20),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? KAppColors.kPrimary : Colors.grey.shade300,
              width: 2),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
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
            const SizedBox(width: 25),
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
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildGroupList(Map<String, dynamic> groupDetails) {
    String? firstImage;
    if (groupDetails['image'] is List &&
        (groupDetails['image'] as List).isNotEmpty) {
      firstImage = groupDetails['image'][0];
      print(firstImage);
    }
    return Container(
      width: 400,
      height: 80,
      margin: const EdgeInsets.only(bottom: 15,left: 20,right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: Color(0xFFCBD5E1),
        ),
        borderRadius: BorderRadius.circular(10),
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
          SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                // image: firstImage != null
                //     ? NetworkImage(firstImage)
                //     : AssetImage('assets/logo/group.png') as ImageProvider,
                image: NetworkImage(groupDetails['image']),
                fit: BoxFit.cover,
              ),
            ),
            height: 60,
            width: 60,
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 170,
            height: 60,
            child: Column(
              children: [
                const SizedBox(height: 15),
                SizedBox(
                  width: 170,
                  height: 25,
                  child: Text(
                    '${groupDetails['groupName']}',
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      color: KAppColors.kPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
                  constraints:
                      const BoxConstraints(minWidth: 380.0, minHeight: 60),
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
                      backgroundColor:
                          WidgetStateProperty.all(KAppColors.kPrimary),
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

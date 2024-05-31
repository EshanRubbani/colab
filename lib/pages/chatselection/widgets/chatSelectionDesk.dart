import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/pages/chatpage/chatpage.dart';
import 'package:collab/pages/chatselection/widgets/menu_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';


class ChatSelectionDesk extends StatefulWidget {
  const ChatSelectionDesk({ super.key });

  @override
  _ChatSelectionDeskState createState() => _ChatSelectionDeskState();
}

class _ChatSelectionDeskState extends State<ChatSelectionDesk> {
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
    final size = MediaQuery.of(context).size;
        final FirestoreService fireStore = FirestoreService();


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
                       Expanded(
                        child: Builder(
                          builder: (context) {
                            return GestureDetector(
                              onDoubleTap: (){
                                showPopover(
                                    context: context,
                                    bodyBuilder: (context) => const Padding(
                                      padding: EdgeInsets.all(8.0), // Add padding here
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
                              child: SizedBox(
                                child: TextField(
                                  controller: searchController,
                                  showCursor: true,
                                  cursorColor: KAppColors.kPrimary,
                                  
                              
                                  decoration: const InputDecoration(
                                      hintText: 'Select Users to Send Message',
                                      border: InputBorder.none),
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 0.09,
                                  ),
                                  enableInteractiveSelection: true,
                                ),
                              ),
                            );
                          }
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
                child: SizedBox(
                  // color: Colors.grey.shade500,
                  width: 360,
                  height: size.height / 1.34,
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
                  )
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
                SizedBox(
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
                SizedBox(
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
                SizedBox(
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
                SizedBox(
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
                SizedBox(
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
                SizedBox(
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
  const MyCheckboxWidget({super.key});

  // Changed to StatefulWidget
  @override
  // ignore: library_private_types_in_public_api
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
                            WidgetStateProperty.all(KAppColors.kPrimary),
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


Widget _buildUserList(Map<String, dynamic> user, bool isSelected, DocumentSnapshot userDoc) {
   if(user["email"] != FirebaseAuth.instance.currentUser!.email){
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
                                  image:  DecorationImage(
                                     image: user['userIMG']?.isNotEmpty ?? false
                                                  ? NetworkImage(user['userIMG']) as ImageProvider
                                                  : const AssetImage('assets/images/profile.png'),
                                      fit: BoxFit.cover),
                                ),
                                height: 60,
                                width: 60,
                                // color: Colors.black,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              SizedBox(
                                width: 170,
                                height: 60,
                                // color: Colors.black,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      // color: Colors.black,
                                      width: 170,
                                      height: 25,
                                      child:  Text(
                                       '${user['firstName'] ?? 'First Name'} ${user['lastName'] ?? 'Last Name'}',
                                        style: const TextStyle(
                                          fontFamily: "Inter",
                                          fontSize: 14,
                                          color: KAppColors.kPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                      width: 170,
                                      // color: Colors.black,
                                      child: Text(
                                        user['email'] ?? 'Email',
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
                                  child: const MyCheckboxWidget())
                            ],
                          ),
                        );
   }else{
     return Container();
   }


}
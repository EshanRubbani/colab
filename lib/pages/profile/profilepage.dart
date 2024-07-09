import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Collab/extras/utils/Helper/firestore.dart';
import 'package:Collab/extras/utils/res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../extras/utils/constant/navbarm.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Move variables inside the state
 
  FirestoreService firestoreService = FirestoreService();
   late User user;
  late String userIdentifier;

  @override
  void initState() {
    super.initState();
    // Fetch the current user in initState
    user = FirebaseAuth.instance.currentUser!;
    userIdentifier = user.email ?? user.phoneNumber!;
  }

  @override
  void dispose() {
    // Dispose of any resources or listeners here
    // For example, if you have any subscriptions, you can cancel them here.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    if (user.email == null && user.phoneNumber == null) {
      return const Center(child: Text('No user data found.'));
    }

    return Scaffold(
        body: ResponsiveNess(
            mobile: _buildForMobile(context),
            desktop: _buildForDesktop(context)));
  }

Widget _buildForDesktop(BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  return LayoutBuilder(
    builder: (context, constraints) {
      double availableWidth = constraints.maxWidth * 0.75;
      double contentWidth = availableWidth < 400 ? availableWidth : 400;

      return Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: size.height - 160,
            width: contentWidth,
            child: StreamBuilder<DocumentSnapshot>(
              stream: userIdentifier.isNotEmpty
                  ? FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userIdentifier)
                      .snapshots()
                  : null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return const Center(child: Text('No user data found.'));
                } else {
                  final data = snapshot.data!.data() as Map<String, dynamic>;

                  data.remove('userUID');
                  final userImg = data.remove('userIMG');

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                userImg ?? 'https://via.placeholder.com/150'),
                          ),
                          const SizedBox(height: 20),
                          for (var entry in data.entries)
                            if (entry.key != 'userUID' && entry.key != 'userIMG' && entry.key != 'joinedGroups')
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      entry.key == "timestamp"
                                          ? "Joined on:"
                                          : '${entry.key.capitalizeFirst} ',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    Text(
                                      entry.key == 'timestamp'
                                          ? _formatTimestamp(entry.value)
                                          : '${entry.value}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                          const SizedBox(height: 20),
                          const Text(
                            "Joined Groups",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: data['joinedGroups']?.length ?? 0,
                              itemBuilder: (context, index) {
                                final groupId = data['joinedGroups'][index];
                                return FutureBuilder<Map<String, dynamic>?>(
                                  future: firestoreService.fetchGroupDetails(groupId),
                                  builder: (context, groupSnapshot) {
                                    if (groupSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const ListTile(
                                        title: Text('Loading...'),
                                      );
                                    } else if (groupSnapshot.hasError) {
                                      return ListTile(
                                        title: Text('Error: ${groupSnapshot.error}'),
                                      );
                                    } else if (!groupSnapshot.hasData ||
                                        groupSnapshot.data == null) {
                                      return const ListTile(
                                        title: Text('Group not found'),
                                      );
                                    } else {
                                      final groupDetails = groupSnapshot.data!;
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: ListTile(
                                          title: Text(
                                            '${index + 1}. ${groupDetails['groupName']}',
                                            style: const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: BoxConstraints(maxWidth: 400),
              child: BottomNavm(index: 4),
            ),
          ),
        ],
      );
    },
  );
}

  
  Widget _buildForMobile(context) {
  final size = MediaQuery.of(context).size;
  print(userIdentifier);
  return Column(
    children: [
      Container(
        height: size.height - 135,
        width: size.width,
        child: StreamBuilder<DocumentSnapshot>(
          stream: userIdentifier.isNotEmpty
              ? FirebaseFirestore.instance
                  .collection('Users')
                  .doc(userIdentifier)
                  .snapshots()
              : null, // Set stream to null if userIdentifier is empty
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.data() == null) {
              return const Center(child: Text('No user data found.'));
            } else {
              final data = snapshot.data!.data() as Map<String, dynamic>;

              // Remove userUID and userIMG from data
              data.remove('userUID');
              final userImg = data.remove('userIMG');

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 250),

                      // Profile Picture
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            userImg ?? 'https://via.placeholder.com/150'),
                      ),
                      const SizedBox(height: 20),

                      // Display all fields dynamically except userUID and userIMG
                      for (var entry in data.entries)
                        if (entry.key != 'userUID' && entry.key != 'userIMG'&& entry.key != 'joinedGroups')
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              children: [
                                Text(
                                 entry.key == "timestamp"? "Joined on:": '${entry.key.capitalizeFirst} ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Text(
                                  entry.key == 'timestamp'
                                      ? _formatTimestamp(entry.value)
                                      : '${entry.value}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),

                      const SizedBox(height: 20),

                      // Joined Groups
                      const Text(
                        "Joined Groups",
                        style:
                            TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      // Display Joined Groups
                      Expanded(
                        child: ListView.builder(
                          itemCount: data['joinedGroups']?.length ?? 0,
                          itemBuilder: (context, index) {
                            final groupId = data['joinedGroups'][index];
                            return FutureBuilder<Map<String, dynamic>?>(
                              future: firestoreService.fetchGroupDetails(groupId),
                              builder: (context, groupSnapshot) {
                                if (groupSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const ListTile(
                                    title: Text('Loading...'),
                                  );
                                } else if (groupSnapshot.hasError) {
                                  return ListTile(
                                    title: Text('Error: ${groupSnapshot.error}'),
                                  );
                                } else if (!groupSnapshot.hasData ||
                                    groupSnapshot.data == null) {
                                  return const ListTile(
                                    title: Text('Group not found'),
                                  );
                                } else {
                                  final groupDetails = groupSnapshot.data!;
                                  return ListTile(
                                    title: Text(
                                      '${index + 1}. ${groupDetails['groupName']}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
      const Align(
        alignment: Alignment.bottomCenter,
        child: BottomNavm(index: 4),
      ),
    ],
  );
}

String _formatTimestamp(Timestamp timestamp) {
  final DateTime date = timestamp.toDate();
  return '${date.day}-${date.month}-${date.year}';
}

}

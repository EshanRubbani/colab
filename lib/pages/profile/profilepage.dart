import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/res.dart';
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
        // Calculate the available width for the profile content
        double availableWidth = constraints.maxWidth * 0.75; // Adjust the percentage as needed
        double contentWidth = availableWidth < 400 ? availableWidth : 400; // Limit the maximum width

        return Column(
          children: [
            SizedBox(height: 10,),
            Container(
              // color: Colors.red,
              height: size.height - 160,
              width: contentWidth, // Use calculated width
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userIdentifier)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data?.data() as Map<String, dynamic>?;

                    if (data == null) {
                      return const Center(child: Text('No user data found.'));
                    }

                    return Column(
                      children: [
                        // Profile Picture
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            data['userIMG'] ?? 'https://via.placeholder.com/150',
                          ),
                        ),
                        const SizedBox(height: 20),

                        // First Name and Last Name
                        Text(
                          '${data['firstName'] ?? 'First Name'} ${data['lastName'] ?? 'Last Name'}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          'Desktop',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Email or Phone Number
                        Text(
                          user.email ?? user.phoneNumber!,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),

                        // Joined Groups
                        const Text(
                          "Joined Groups",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
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

                                    return Padding(
                                      padding: const EdgeInsets.only(left: 16.0),
                                      child: ListTile(
                                        title: Text(
                                          '${index + 1}. ${groupDetails['groupName']}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
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
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(height: 10,),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                constraints: BoxConstraints(maxWidth: 400), // Use calculated width
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
                            data['userIMG'] ?? 'https://via.placeholder.com/150'),
                      ),
                      const SizedBox(height: 20),

                      // First Name and Last Name
                      Text(
                        '${data['firstName'] ?? 'First Name'} ${data['lastName'] ?? 'Last Name'}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        'Mobile',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Email or Phone Number
                      Text(
                        user.email ?? user.phoneNumber!,
                        style: const TextStyle(fontSize: 18),
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
}

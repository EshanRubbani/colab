import 'dart:io';

import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/pages/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Collab/extras/utils/Helper/firestore.dart';
import 'package:Collab/extras/utils/res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../extras/utils/constant/navbarm.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Move variables inside the state

  FirestoreService firestoreService = FirestoreService();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  late User user;
  late String userIdentifier;
   TextEditingController firstNameController =
                                    TextEditingController();
                                TextEditingController lastNameController =
                                    TextEditingController();
                                TextEditingController usernameController =
                                    TextEditingController();

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

  Future<void> updateOwnerDpInPosts(String oldOwnerDp, String newOwnerDp) async {
  final firestore = FirebaseFirestore.instance;

  try {
    // Query the Posts collection where ownerDp matches the oldOwnerDp
    QuerySnapshot querySnapshot = await firestore
        .collection("Posts")
        .where("ownerDp", isEqualTo: oldOwnerDp)
        .get();

    // Iterate through each document and update the ownerDp
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.update({
        "ownerDp": newOwnerDp,
      });
    }
    Get.snackbar("Success", "All matching ownerDp fields have been updated successfully.");
   
  } catch (e) {
    print("");
     Get.snackbar("Error", "Error updating ownerDp in Posts: $e");
        
      }
}

  Future<void> pickImage(String oldIMG) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage(oldIMG);
    }
  }

  Future<void> _uploadImage(String oldIMG) async {
    if (_image == null) return;

    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final ref = _storage.ref().child(
          'users/${FirebaseAuth.instance.currentUser!.email.toString()}.jpg');
      await ref.putFile(_image!);
      final url = await ref.getDownloadURL();
      print('Image uploaded: $url');

      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.email.toString())
            .update({
          'userIMG': url,
        });

        updateOwnerDpInPosts(oldIMG, url);

        Navigator.of(context).pop(); // Dismiss the loading dialog
        Get.snackbar("Success", "Image Uploaded Successfully. Please Login Now.");
        
      } catch (e) {
        Navigator.of(context).pop(); // Dismiss the loading dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.toString()),
            );
          },
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Dismiss the loading dialog
      print('Error uploading image: $e');
    }
  }  
Future<bool> checkIfUsernameTaken(String username) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection("Users")
      .where("userName", isEqualTo: username)
      .get();

  return querySnapshot.docs.isNotEmpty;
}

Future<void> updateUserInfo(String email, String newFirstName, String newLastName, String newUserName,String oldUserName) async {
  DocumentReference userRef = FirebaseFirestore.instance.collection('Users').doc(email);

  try {
    // Check if the new username is already taken by someone else
    bool isUsernameTaken = await checkIfUsernameTaken(newUserName);
    if (isUsernameTaken) {
      Get.snackbar("Invalid UserName", "Username already taken");
      return;
    }
    updateOwnerNameInPosts(oldUserName, newUserName);
    // Update the user's information
    await userRef.update({
      'firstName': newFirstName,
      'lastName': newLastName,
      'userName': newUserName,
    });

    Get.snackbar("Success", 'User information updated successfully');
   Navigator.pop(context); 
   Get.to(HomeScreen());
  } catch (e) {
    Get.snackbar("Error", e.toString());
  }
}
Future<void> updateOwnerNameInPosts(String oldUsername, String newUsername) async {
  final firestore = FirebaseFirestore.instance;

  try {
    // Query the Posts collection where ownerName matches the oldUsername
    QuerySnapshot querySnapshot = await firestore
        .collection("Posts")
        .where("ownerName", isEqualTo: oldUsername)
        .get();

    // Iterate through each document and update the ownerName
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.update({
        "ownerName": newUsername,
      });
    }

    print("All matching ownerName fields have been updated successfully.");
  } catch (e) {
    print("Error updating ownerName in Posts: $e");
  }
}
Future<String?> getCurrentUsername() async {
  // Get the current user
  User? user = FirebaseAuth.instance.currentUser;

  // Check if the user is signed in
  if (user == null) {
    return null; // or throw an error
  }

  // Get the user's document from Firestore
  DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(user.email)
      .get();

  // Check if the document exists
  if (userDoc.exists) {
    // Extract the username field
    return userDoc['userName'] as String?;
  } else {
    return null; // or handle the case where the user document doesn't exist
  }
}

void signup(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: SpinKitChasingDots(
          color: KAppColors.kPrimary,
          size: 80,
        ),
      );
    },
  );

  try {
    // Check if username is already taken
    bool isUsernameTaken = await checkIfUsernameTaken(usernameController.text);
    if (isUsernameTaken) {
      // Pop the loading circle
      Navigator.pop(context);
      Get.snackbar("Invalid UserName", "Username already taken");
      return;
    } else {
      String? oldUsername = await getCurrentUsername();
       if (oldUsername != null) {
    print('Username: $oldUsername');
    await updateUserInfo(
        FirebaseAuth.instance.currentUser!.email.toString(),
        firstNameController.text,
        lastNameController.text,
        usernameController.text,
        oldUsername,

      );
  } else {
    print('User not found or not signed in');
  }
      // Update user info if username is not taken
      
    }

    // Pop the loading circle after successful operation
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    // Pop the loading circle
    Navigator.pop(context);
    Get.snackbar("Error", e.code);
  } catch (e) {
    // Handle any other exceptions
    Navigator.pop(context);
    Get.snackbar("Error", e.toString());
  }
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
                  } else if (!snapshot.hasData ||
                      snapshot.data!.data() == null) {
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
                              if (entry.key != 'userUID' &&
                                  entry.key != 'userIMG' &&
                                  entry.key != 'joinedGroups')
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        entry.key == "timestamp"
                                            ? "Joined on:"
                                            : '${entry.key.capitalizeFirst} ',
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
                                    future: firestoreService
                                        .fetchGroupDetails(groupId),
                                    builder: (context, groupSnapshot) {
                                      if (groupSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const ListTile(
                                          title: Text('Loading...'),
                                        );
                                      } else if (groupSnapshot.hasError) {
                                        return ListTile(
                                          title: Text(
                                              'Error: ${groupSnapshot.error}'),
                                        );
                                      } else if (!groupSnapshot.hasData ||
                                          groupSnapshot.data == null) {
                                        return const ListTile(
                                          title: Text('Group not found'),
                                        );
                                      } else {
                                        final groupDetails =
                                            groupSnapshot.data!;
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: ListTile(
                                            title: Text(
                                              '${index + 1}. ${groupDetails['groupName']}',
                                              style:
                                                  const TextStyle(fontSize: 18),
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
          height: size.height - 100,
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
                        builddp(userImg),
                        const SizedBox(height: 20),

                        // Display all fields dynamically except userUID and userIMG
                        for (var entry in data.entries)
                          if (entry.key != 'userUID' &&
                              entry.key != 'userIMG' &&
                              entry.key != 'joinedGroups')
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                children: [
                                  Text(
                                    entry.key == "timestamp"
                                        ? "Joined on:"
                                        : '${entry.key.capitalizeFirst} ',
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
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // TextEditingController instances to manage text input
                               

                                return AlertDialog(
                                  title: Text("Update Profile Information"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: firstNameController,
                                        decoration: InputDecoration(
                                          labelText: "First Name",
                                        ),
                                      ),
                                      TextField(
                                        controller: lastNameController,
                                        decoration: InputDecoration(
                                          labelText: "Last Name",
                                        ),
                                      ),
                                      TextField(
                                        controller: usernameController,
                                        decoration: InputDecoration(
                                          labelText: "Username",
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Handle cancel action
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        signup(context);
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            KAppColors.kButtonPrimary,
                                      ),
                                      child: Text("Save"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: KAppColors.kButtonPrimary,
                          ),
                          child: Text(
                            "Update Profile Information",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        const SizedBox(height: 20),
                        // Joined Groups
                        const Text(
                          "Joined Groups",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        // Display Joined Groups
                        Expanded(
                          child: ListView.builder(
                            itemCount: data['joinedGroups']?.length ?? 0,
                            itemBuilder: (context, index) {
                              final groupId = data['joinedGroups'][index];
                              return FutureBuilder<Map<String, dynamic>?>(
                                future:
                                    firestoreService.fetchGroupDetails(groupId),
                                builder: (context, groupSnapshot) {
                                  if (groupSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const ListTile(
                                      title: Text('Loading...'),
                                    );
                                  } else if (groupSnapshot.hasError) {
                                    return ListTile(
                                      title:
                                          Text('Error: ${groupSnapshot.error}'),
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
                                            fontWeight: FontWeight.bold),
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

   builddp(userImg) {
     return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(userImg ?? 'https://via.placeholder.com/150'),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: (){
               pickImage(userImg);
            },
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime date = timestamp.toDate();
    return '${date.day}-${date.month}-${date.year}';
  }
  
 
}

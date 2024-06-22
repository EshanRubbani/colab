import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    if (user.email == null && user.phoneNumber == null) {
      return const Center(child: Text('No user data found.'));
    }

    final userIdentifier = user.email ?? user.phoneNumber;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
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

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
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

                    // Email or Phone Number
                    Text(
                      user.email ?? user.phoneNumber!,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

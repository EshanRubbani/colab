import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

final currentUser = (auth.currentUser?.email?.isNotEmpty ?? false) 
    ? auth.currentUser!.email 
    : auth.currentUser!.phoneNumber;

class GroupFunctions{
Future<String> createGroup(String groupName, List<String> memberIds, String image) async {
  String groupId = firestore.collection('groups').doc().id;
  String userId = auth.currentUser!.uid;


  print(currentUser);
  print(groupName);
  print(image);


// Create the group document in Firestore
  await firestore.collection('groups').doc(groupId).set({
    'groupId': groupId,
    'groupName': groupName,
    'admin': userId,
    'members': memberIds,
    'image': image,
    'createdAt': FieldValue.serverTimestamp(),
  });

  print("Group created successfully");
  //add group creating admin and save group id into user document
await firestore.collection('Users').doc(currentUser).set({
  'joinedGroups': FieldValue.arrayUnion([groupId])
}, SetOptions(merge: true));

  print(" Join Group added successfully");

  

  return groupId;
}


Future<void> addMemberToGroup(String groupId, String memberId) async {
  print('Starting add process');
  print('Group ID: $groupId');
  print('Member ID: $memberId');

  try {
    // Check if groupId or memberId contains slashes
    if (groupId.contains('/') || memberId.contains('/')) {
      throw Exception('Document ID must not contain slashes ("/").');
    }

    print('Adding Member to Group');

    // Update the 'members' field in the 'groups' collection to include the new member
    await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([memberId])
    });
    
    print('Updating User Document');

    // Update the 'joinedGroups' field in the 'Users' collection to include the group ID
    await FirebaseFirestore.instance.collection('Users').doc(currentUser).set({
      'joinedGroups': FieldValue.arrayUnion([groupId])
    }, SetOptions(merge: true));

    print("Member added successfully");
  } catch (e) {
    print("Failed to add member: $e");
  }
}

Future<void> deleteGroup(String groupId) async {
  DocumentSnapshot groupDoc = await firestore.collection('groups').doc(groupId).get();
  List<dynamic> members = groupDoc['members'];

  for (String memberId in members) {
    await firestore.collection('users').doc(memberId).update({
      'groups': FieldValue.arrayRemove([groupId]),
    });
  }

  await firestore.collection('groups').doc(groupId).delete();
}


}
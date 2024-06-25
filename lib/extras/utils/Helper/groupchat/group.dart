import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

final currentUser = (auth.currentUser?.email?.isNotEmpty ?? false) 
    ? auth.currentUser!.email 
    : auth.currentUser!.phoneNumber;

class GroupFunctions{
Future<String> createGroup(String groupName, List<String> memberIds) async {
  String groupId = firestore.collection('groups').doc().id;
  String userId = auth.currentUser!.uid;


  print(currentUser);



// Create the group document in Firestore
  await firestore.collection('groups').doc(groupId).set({
    'groupId': groupId,
    'groupName': groupName,
    'admin': userId,
    'members': memberIds,
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
  try {
    // Reference to the specific group document
    DocumentReference groupRef = FirebaseFirestore.instance.collection('groups').doc(groupId);

    // Add the new member to the 'members' array field
    await groupRef.update({
      'members': FieldValue.arrayUnion([memberId])
    });

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
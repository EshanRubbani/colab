import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Collab/extras/utils/Helper/chat/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // Get instance of Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get Users Stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshots) {
      return snapshots.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // Create a new group chat
  Future<void> createGroup(String groupName, List<String> memberIDs) async {
    final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    final String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    final String groupID = _firestore.collection("Groups").doc().id;
    
    await _firestore.collection("Groups").doc(groupID).set({
      'groupName': groupName,
      'memberIDs': memberIDs,
      'adminID': currentUserID,
      'createdAt': Timestamp.now(),
    });
  }

  // Send message
  Future<void> sendMessage(String chatID, String message,bool isGroup ) async {
    final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    final user = FirebaseAuth.instance.currentUser!;
    final userIdentifier = user.email ?? user.phoneNumber!;
    final Timestamp timestamp = Timestamp.now();

    // Create new Message
    Message newMessage = Message(
      senderID: currentUserID,
      receiverID: chatID,
      senderEmail: userIdentifier,
      message: message,
      timestamp: timestamp,
    );

    if (isGroup) {
      await _firestore.collection("Groups").doc(chatID).collection("messages").add(newMessage.toMap());
    } else {
      List<String> ids = [currentUserID, chatID];
      ids.sort(); // Sort the ids
      String chatroomID = ids.join("_");
      await _firestore.collection("ChatRooms").doc(chatroomID).collection("messages").add(newMessage.toMap());
    }
  }

  // Get messages for one-to-one chat
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort(); // Sort the ids
    String chatroomID = ids.join("_");

    return _firestore.collection("ChatRooms").doc(chatroomID).collection("messages").orderBy("timestamp", descending: false).snapshots();
  }

  // Get messages for group chat
  Stream<QuerySnapshot> getGroupMessages(String groupID) {
    return _firestore.collection("Groups").doc(groupID).collection("messages").orderBy("timestamp", descending: false).snapshots();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/chat/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService{
  // get instance of firestore

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get Users Stream

  Stream<List<Map<String, dynamic>>> getUsersStream(){
    return _firestore.collection("Users").snapshots().map((snapshots){
      return snapshots.docs.map((doc){
        final user = doc.data();
        return user;
      }).toList();
    
    });
  }



  // send message 
  
  Future<void> sendMessage(String receiverID, message )async{
    //get current user info
    final String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    final String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    
    //create new Message
   Message newMessage = Message(
    senderID: currentUserID, 
    receiverID: receiverID, 
    senderEmail: currentUserEmail, 
    message: message, 
    timestamp: timestamp,
    );




    //construct chatroomID for two users (sorted to ensure uniqueness)

    List<String> ids = [currentUserID, receiverID];
    ids.sort(); //sort the ids
    String chatroomID = ids.join("_");

    //add message to chatroomID
    await _firestore.collection("ChatRooms").doc(chatroomID).collection("messages").add(newMessage.toMap());

  }


  
  //get message 

  Stream<QuerySnapshot> getMessages(String userID, otherUserID){

      //construct chat room ids for two users (sorted to ensure uniqueness)
      

    List<String> ids = [userID, otherUserID];
    ids.sort(); //sort the ids
    String chatroomID = ids.join("_");

    return _firestore.collection("ChatRooms").doc(chatroomID).collection("messages").orderBy("timestamp",descending: false).snapshots();
  }

}
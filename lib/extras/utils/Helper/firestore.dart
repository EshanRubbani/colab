import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStore {
  // Get current user
  User? user = FirebaseAuth.instance.currentUser;
  String? currentemail = FirebaseAuth.instance.currentUser!.email.toString();
  // Collection reference
  final CollectionReference posts =
      FirebaseFirestore.instance.collection("Posts");

// Get Users collection

  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

//get current user data refernce

//get first name and last nameee

  // Add post
  Future<void> addPost(
    String itemName,
    String ownerName,
    int backed,
    int itemPercent,
    String itemImg,
    String ownerDp,
    String owneremail,
  ) {
    return posts.add({
      'itemName': itemName,
      'ownerName': ownerName,
      'backed': backed,
      'itemPercent': itemPercent,
      'itemImg': itemImg,
      'ownerDp': ownerDp,
      'timestamp': Timestamp.now(),
      'owneremail': owneremail,
    });
  }

  // Get posts stream
  Stream<QuerySnapshot> getPostsStream() {
    return posts.orderBy('timestamp', descending: true).snapshots();
  }
}

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStore {
//get current useer
  User? user = FirebaseAuth.instance.currentUser;

//read data
//get collections of posts document

  final CollectionReference posts =
      FirebaseFirestore.instance.collection("Posts");

//write data
//add post

  Future<void> addPost(
    String itemName,
    String ownerName,
    int backed,
    int itemPercent,
    String itemImg,
    String ownerDp,
  ) {
    return posts.add({
      'itemName': itemName,
      'ownerName': ownerName,
      'backed': backed,
      'itemPercent': itemPercent,
      'itemImg': itemImg,
      'ownerDp': ownerDp,
      'timestamp': Timestamp.now(),
    });
  }

  //read post from posts document

  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection("Posts")
        .orderBy('timestamp', descending: true)
        .snapshots();

    return postsStream;
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStore {
  // Get current user
  User? user = FirebaseAuth.instance.currentUser;

  // Collection reference
  final CollectionReference posts =
      FirebaseFirestore.instance.collection("Posts");

  // Add post
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

  // Get posts stream
  Stream<QuerySnapshot> getPostsStream() {
    return posts.orderBy('timestamp', descending: true).snapshots();
  }
}

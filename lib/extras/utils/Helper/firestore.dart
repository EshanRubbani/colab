import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/post_model.dart';
import 'package:collab/extras/utils/Helper/usermodel.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Posts collection reference
  CollectionReference get _postsCollection => _db.collection('Posts');

  // Users collection reference
  CollectionReference get _usersCollection => _db.collection('Users');

  // Create or Update Post
  Future<void> setPost(Post post, int backed, int itemPercent, String itemImg,
      String ownerName, String ownerDp, String owneremail) async {
    await _postsCollection.doc(post.id).set(post.toDocument());
  }

  // Get Post by ID
  Future<Post?> getPost(String id) async {
    DocumentSnapshot doc = await _postsCollection.doc(id).get();
    if (doc.exists) {
      return Post.fromDocument(doc);
    }
    return null;
  }

  // Delete Post
  Future<void> deletePost(String id) async {
    await _postsCollection.doc(id).delete();
  }

  // Create or Update User
  Future<void> setUser(User user) async {
    await _usersCollection.doc(user.id).set(user.toDocument());
  }

  // Get User by ID
  Future<User?> getUser(String id) async {
    DocumentSnapshot doc = await _usersCollection.doc(id).get();
    if (doc.exists) {
      return User.fromDocument(doc);
    }
    return null;
  }

  // Get posts stream
  Stream<QuerySnapshot> getPostsStream() {
    return _postsCollection.orderBy('timestamp', descending: true).snapshots();
  }

  // Delete User
  Future<void> deleteUser(String id) async {
    await _usersCollection.doc(id).delete();
  }
}


































// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FireStore {
//   // Get current user
//   User? user = FirebaseAuth.instance.currentUser;
//   String? currentemail = FirebaseAuth.instance.currentUser!.email.toString();
//   // Collection reference
//   final CollectionReference posts =
//       FirebaseFirestore.instance.collection("Posts");

// // Get Users collection

//   final CollectionReference users =
//       FirebaseFirestore.instance.collection("users");

// //get current user data refernce

// //get first name and last nameee

//   // Add post
//   Future<void> addPost(
//     String itemName,
//     String ownerName,
//     int backed,
//     int itemPercent,
//     String itemImg,
//     String ownerDp,
//     String owneremail,
//   ) {
//     return posts.add({
//       'itemName': itemName,
//       'ownerName': ownerName,
//       'backed': backed,
//       'itemPercent': itemPercent,
//       'itemImg': itemImg,
//       'ownerDp': ownerDp,
//       'timestamp': Timestamp.now(),
//       'owneremail': owneremail,
//     });
//   }


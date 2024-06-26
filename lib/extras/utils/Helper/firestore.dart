import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/utils/Helper/post_model.dart';
import 'package:collab/extras/utils/Helper/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth_user;


class FirestoreService {
  
  final FirebaseFirestore _db = FirebaseFirestore.instance;

 
  /* -----------------------------POSTS---------------------------------*/

  
   // Posts collection reference
  CollectionReference get _postsCollection => _db.collection('Posts');


  // Create or Update Post
  Future<void> setPost(int backed, int itemPercent, String itemImg, String itemName,
      String ownerName, String ownerDp, Timestamp timestamp, String selectedItemType, String scope,String groupId,String category) async {

    try{
      print("arrived at set post");
       await _postsCollection.doc().set(
      {
        'itemName': itemName,
        'backed': backed,
        'itemPercent': itemPercent,
        'itemImg': itemImg,
        'ownerName': ownerName,
        'ownerDp': ownerDp,
        'selectedItemType': selectedItemType,
        'scope': scope,
        'timestamp': timestamp,
        'groupId': groupId,
        'category': category,
        


    });}
    catch(e){
      print("at firestore create post");
      print(e);
    }
    
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


  // Get posts stream
  Stream<QuerySnapshot> getPostsStream() {
    return _postsCollection.orderBy('timestamp', descending: true).snapshots();
  }

  /* -----------------------------USERS---------------------------------*/


  // Get current user
  auth_user.User? user = auth_user.FirebaseAuth.instance.currentUser;
  String? currentemail = auth_user.FirebaseAuth.instance.currentUser!.email.toString();


  // Users collection reference
  CollectionReference get _usersCollection => _db.collection('Users');


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


  // Delete User
  Future<void> deleteUser(String id) async {
    await _usersCollection.doc(id).delete();
  }


   // Get users stream
  Stream<QuerySnapshot> getUsersStream() {
    return _usersCollection.orderBy('timestamp', descending: true).snapshots();
  }

// Get User profile image by current user email
Future<String?> getUserProfileImage(String email) async {
  try {
    QuerySnapshot snapshot = await _usersCollection.where('email', isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty) {
      User user = User.fromDocument(snapshot.docs.first);
      return user.userImg;
    }
    return null;
  } catch (e) {
    print("Error getting user profile image: $e");
    return null;
  }
}



  //  // Get Single  users Data Form Users Stream
  // Stream<Map<String, dynamic>> getUserInfo() {

  //   return _usersCollection.snapshots().map((snapshot){
  //           return snapshot.docs.map((doc) {
  //             final user = doc.data();
              
  //             return user;
  //           }).toList();
  //   });
  // }



  /* -----------------------------Groups---------------------------------*/
  Future<Map<String, dynamic>?> fetchGroupDetails(String groupId) async {
  try {
    DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .get();

    if (groupSnapshot.exists) {
      return groupSnapshot.data() as Map<String, dynamic>?;
    } else {
      print('Group not found');
      return null;
    }
  } catch (e) {
    print('Error fetching group details: $e');
    return null;
  }
}


  //Joined Group Collection reference
  CollectionReference get _joinedGroupCollection => _db.collection('groups');


   // Get Joined Group stream
  Stream<QuerySnapshot> getGroupStream() {
    return _joinedGroupCollection.orderBy('timestamp', descending: true).snapshots();
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


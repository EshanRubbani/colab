import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  int backed;
  String itemImg;
  String itemName;
  int itemPercent;
  String ownerID;
  String ownerName;
  Timestamp timestamp;

  Post({
    required this.id,
    required this.backed,
    required this.itemImg,
    required this.itemName,
    required this.itemPercent,
    required this.ownerID,
    required this.ownerName,
    required this.timestamp,
  });

  // Convert a Post from Firestore document
  factory Post.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      backed: data['backed'],
      itemImg: data['itemImg'],
      itemName: data['itemName'],
      itemPercent: data['itemPercent'],
      ownerID: data['ownerID'],
      ownerName: data['ownerName'],
      timestamp: data['timestamp'],
    );
  }

  // Convert a Post to Firestore document
  Map<String, dynamic> toDocument() {
    return {
      'backed': backed,
      'itemImg': itemImg,
      'itemName': itemName,
      'itemPercent': itemPercent,
      'ownerID': ownerID,
      'ownerName': ownerName,
      'timestamp': timestamp,
    };
  }
}

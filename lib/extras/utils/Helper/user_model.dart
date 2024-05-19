import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String email;
  String firstName;
  String lastName;
  Timestamp timestamp;
  String userImg;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.timestamp,
    required this.userImg,
  });

  // Convert a User from Firestore document
  factory User.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      timestamp: data['timestamp'],
      userImg: data['userIMG'],
    );
  }

  // Convert a User to Firestore document
  Map<String, dynamic> toDocument() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'timestamp': timestamp,
      'userIMG': userImg,
    };
  }
}
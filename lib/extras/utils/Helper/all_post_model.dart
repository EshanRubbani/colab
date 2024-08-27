import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Item {
  String backed;
  List<String> itemImg;
  String itemName;
  String itemPercent;
  String ownerDp;
  String ownerName;
  String selectedItemType;
  String category;
  String charges;
  String cost;
  String currentBackers;
  String description;
  String groupId;
  String scope;
  Timestamp timestamp;
  String totalBackers;

  Item({
    required this.backed,
    required this.itemImg,
    required this.itemName,
    required this.itemPercent,
    required this.ownerDp,
    required this.ownerName,
    required this.selectedItemType,
    required this.category,
    required this.charges,
    required this.cost,
    required this.currentBackers,
    required this.description,
    required this.groupId,
    required this.scope,
    required this.timestamp,
    required this.totalBackers,
  });

  factory Item.fromSnapshot(DataSnapshot snapshot) {
    Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

    return Item(
      backed: data?['backed'] ?? '',
      itemImg: (data?['itemImg'] as List<dynamic>?)
                 ?.map((e) => e.toString())
                 .toList() ?? [],
      itemName: data?['itemName'] ?? '',
      itemPercent: data?['itemPercent'] ?? '',
      ownerDp: data?['ownerDp'] ?? '',
      ownerName: data?['ownerName'] ?? '',
      selectedItemType: data?['selectedItemType'] ?? '',
      category: data?['category'] ?? '',
      charges: data?['charges'] ?? '',
      cost: data?['cost'] ?? '',
      currentBackers: data?['currentbackers'] ?? '',
      description: data?['description'] ?? '',
      groupId: data?['groupId'] ?? '',
      scope: data?['scope'] ?? '',
      timestamp: data?['timestamp'] ?? '',
      totalBackers: data?['totalbackers'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'backed': backed,
      'itemImg': itemImg,
      'itemName': itemName,
      'itemPercent': itemPercent,
      'ownerDp': ownerDp,
      'ownerName': ownerName,
      'selectedItemType': selectedItemType,
      'category': category,
      'charges': charges,
      'cost': cost,
      'currentbackers': currentBackers,
      'description': description,
      'groupId': groupId,
      'scope': scope,
      'timestamp': timestamp,
      'totalbackers': totalBackers,
    };
  }
}

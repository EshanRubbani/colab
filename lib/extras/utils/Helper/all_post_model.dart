import 'package:firebase_database/firebase_database.dart';

class Item {
  // String id; // To store the unique Firebase key (-NwWMdjhBQunuiqICdJ4, etc.)
  int backed;
  String itemImg;
  String itemName;
  int itemPercent;
  String ownerDp;
  String ownerName;
  String selectedItemType;

  Item({
    //  required this.id,
    required this.backed,
    required this.itemImg,
    required this.itemName,
    required this.itemPercent,
    required this.ownerDp,
    required this.ownerName,
    required this.selectedItemType,
  });

  // Factory constructor to create an Item from a Firebase snapshot
  factory Item.fromSnapshot(DataSnapshot snapshot) {
    Map<String, dynamic>? data;

    if (snapshot.value is Map) {
      data = {};
      (snapshot.value as Map).forEach((key, value) {
        if (key is String) {
          data![key] = value;
        }
      });
    }
    return Item(
      // id: snapshot.key!,
      backed: data!['backed'] ?? 0,
      itemImg: data['item_img'] ?? '',
      itemName: data['item_name'] ?? '',
      itemPercent: data['item_percent'] ?? 0,
      ownerDp: data['owner_dp'] ?? '',
      ownerName: data['owner_name'] ?? '',
      selectedItemType: data['selected_item_type'] ?? '',
    );
  }

  // Method to convert Item back to a Map (for saving to Firebase)
  Map<String, dynamic> toMap() {
    return {
      'backed': backed,
      'item_img': itemImg,
      'item_name': itemName,
      'item_percent': itemPercent,
      'owner_dp': ownerDp,
      'owner_name': ownerName,
    };
  }
}

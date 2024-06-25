import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/common/common_button.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/Helper/groupchat/group.dart';
import 'package:collab/extras/utils/Helper/user_model.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/constant/navbarm.dart';
import 'package:collab/extras/utils/res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirestoreService fireStoreService = FirestoreService();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController backedController = TextEditingController();
  final TextEditingController itemPercentController = TextEditingController();
  final TextEditingController itemImgController = TextEditingController();
  final UserImageHelper _userImageHelper = UserImageHelper();
final List<String> items = [
  'Local Deal',
  'State-Wide Deal',
  'Country-Wide Deal',
  'Global Deal',
];
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var posturl = "Select Item Image";
    Uint8List? _imageBytes; // Use Uint8List for web image representation
    String itemType = 'Product';
  String? selectedValue;

  Widget _buildRadioButtons() { // Helper function for radio buttons
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<String>(
          value: 'Product',
          groupValue: itemType,
          onChanged: (value) => setState(() => itemType = value!),
        ),
        const Text('Product'),
        Radio<String>(
          value: 'Service',
          groupValue: itemType,
          onChanged: (value) => setState(() => itemType = value!),
        ),
        const Text('Service'),
      ],
    );
  }

  Widget _scope() {

    return Container(
      width: 300,

      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            'Select Scope',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: items
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (String? value) {
            setState(() {
              selectedValue = value;
            });
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 40,
            width: 140,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
        ),
      ),





    );
  }


   Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    print("pickedFile: $pickedFile");
    if (pickedFile != null) {
      if (kIsWeb) {
        _imageBytes = await pickedFile.readAsBytes();
         print("bytess: $_imageBytes");

      } else {
        _imageBytes = await File(pickedFile.path).readAsBytes();
      }
      setState(() { _uploadImage();}); // Trigger rebuild after image selection
     
    }
  }

  Future<void> _uploadImage() async {
    if (_imageBytes == null) return;

    Get.dialog(const Center(child: CircularProgressIndicator())); // Use Get.dialog for better overlay

    try {
     final ref = _storage.ref().child('posts/${DateTime.now().millisecondsSinceEpoch}.jpg');
      print("upload task beggining");
      // Upload task: Handles both web and mobile scenarios
      UploadTask uploadTask = 
          kIsWeb 
              ? ref.putData(_imageBytes!) 
              : ref.putFile(File(await _picker.pickImage(source: ImageSource.gallery).then((value) => value!.path)));

      await uploadTask;
      print("upload task finished");
      final url = await ref.getDownloadURL();

      print("url : $url");
      setState(() {
        posturl = url;
      });

      Get.back(); // Close the loading dialog
     
    } catch (e) {
      Get.back(); // Close dialog in case of error
      Get.snackbar("Error", e.toString()); // Show error using Get.snackbar
    }
  }



  Future<String?> ownerimage() async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    return await fireStoreService.getUserProfileImage(email);
  }

  void genericErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

 Future<void> postItem() async {
  String selectedItemType = itemType; 
  if (itemNameController.text.isNotEmpty &&
      backedController.text.isNotEmpty &&
      itemPercentController.text.isNotEmpty &&
      selectedValue != null &&
      posturl != "Select Item Image") {
    String itemName = itemNameController.text;
    int backed = int.parse(backedController.text);
    int itemPercent = int.parse(itemPercentController.text);
    String ownerName = FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
    String itemImg = posturl;
    String owneremail = FirebaseAuth.instance.currentUser!.email!;
    String ownerDp = await _userImageHelper.getUserImage(owneremail);
    Timestamp timestamp = Timestamp.now();
    String scope = selectedValue!;

    try {
      print(itemName);
      print(backed);
      print(itemPercent);
      print(posturl);
      print(ownerName);
      print(ownerDp);
      print(timestamp);
      print(selectedItemType);
     

      // Create group first and get the groupId
      String groupId = await GroupFunctions().createGroup(itemName, [FirebaseAuth.instance.currentUser!.uid]);
     print(groupId);
      print("Calling set post");


      // Set post with groupId
      await fireStoreService.setPost(
        backed, itemPercent, itemImg, itemName, ownerName, ownerDp, timestamp, selectedItemType, scope, groupId
      );

      genericErrorMessage("Successfully Posted");
      setState(() {
        itemNameController.clear();
        backedController.clear();
        itemPercentController.clear();
        posturl = "Select Item Image";
      });
    } on FirebaseException catch (e) {
      genericErrorMessage(e.code);
    }
  } else {
    genericErrorMessage("Please fill all fields");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: const [],
      ),
      body: ResponsiveNess(
        mobile: _buildForMobile(context),
        desktop: _buildForDesktop(context),
      ),
    );
  }

  Widget _buildForDesktop(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        width: size.width / 2,
         
        child: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(19.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 30),
                TextFormField(
                  controller: itemNameController,
                  decoration: InputDecoration(
                    hintText: "Enter Item Name",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: backedController,
                  decoration: InputDecoration(
                    hintText: "Backed",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: itemPercentController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Item Percent",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    await _pickImage();
                  },
                  child: TextFormField(
                    controller: itemImgController,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: posturl,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildRadioButtons(),
                _scope(),
                const SizedBox(height: 30),
                Center(
                  child: ButtonWidget(
                    size: size,
                    color: KAppColors.kButtonPrimary,
                    onTap: postItem,
                    text: "Post Item",
                  ),
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavm(index: 2),
          ),
        ],
          ),
        ),
      ),
    );

  }

  Widget _buildForMobile(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
                Padding(
        padding: const EdgeInsets.all(19.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 30),
            TextFormField(
              controller: itemNameController,
              decoration: InputDecoration(
                hintText: "Enter Item Name",
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: backedController,
              decoration: InputDecoration(
                hintText: "Backed",
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: itemPercentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Item Percent",
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                await _pickImage();
              },
              child: TextFormField(
                controller: itemImgController,
                enabled: false,
                decoration: InputDecoration(
                  hintText: posturl,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildRadioButtons(),
              _scope(),
            const SizedBox(height: 30),
            Center(
              child: ButtonWidget(
                size: size,
                color: KAppColors.kButtonPrimary,
                onTap: postItem,
                text: "Post Item",
              ),
            ),
          ],
        ),
      ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavm(index: 2),
          ),
        ],
      ),
    );
  }
}

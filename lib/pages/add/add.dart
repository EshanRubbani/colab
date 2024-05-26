
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/common/common_button.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/Helper/user_model.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/constant/navbarm.dart';
import 'package:collab/extras/utils/res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
    final user = FirebaseAuth.instance.currentUser!;
  FirestoreService FireStoreService = FirestoreService();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController backedController = TextEditingController();
  final TextEditingController itemPercentController = TextEditingController();
   TextEditingController itemImgController = TextEditingController();
  // Inside your widget
  final UserImageHelper _userImageHelper = UserImageHelper(); 

  File? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
   var posturl = "Select Item Image";



  


  
  
  
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile == null) {
        print('No image selected.');

       
      } else {
        _image = File(pickedFile.path);
        _uploadImage();
        
        
        
             }
    });
  }



  Future<void> _uploadImage() async {
    if (_image == null) return;
    // show loading circle
    
    try {
      final ref = _storage.ref().child(
          'posts/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(_image!);
      final url = await ref.getDownloadURL();
      print('Image uploaded: $url');


       setState(() {
        posturl = url;
       });
        
        
      } catch (e) {
        
        AlertDialog(
          content: Text(e.toString()),
        );
      }
   
  }
  
  
 Future ownerimage() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String email = auth.currentUser!.email!;
    FireStoreService.getUserProfileImage(email);
    String? profileImageUrl = await FireStoreService.getUserProfileImage(email);
   
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
    if (itemNameController.text.isNotEmpty &&
        backedController.text.isNotEmpty &&
        itemPercentController.text.isNotEmpty &&
        posturl != "Select Item Image"
        ) {
      
      

        String itemName = itemNameController.text;
        int backed = int.parse(backedController.text);
        int itemPercent = int.parse(itemPercentController.text);
        String ownerName = FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
        String itemImg =  posturl;
        String owneremail = FirebaseAuth.instance.currentUser!.email!;
        String ownerDp = await _userImageHelper.getUserImage(owneremail);
        Timestamp timestamp = Timestamp.now();

      try {
         print(itemName);
        print(backed);
        print(itemPercent);
        print(posturl);
        print(ownerName);
        print(ownerDp);
        print(timestamp);
        print("calling set post");
        FireStoreService.setPost(
          backed,itemPercent,itemImg,itemName,ownerName,ownerDp,timestamp
        );

      genericErrorMessage("Successfully Posted");

        
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
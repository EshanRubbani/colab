import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/common/common_button.dart';
import 'package:collab/extras/utils/Helper/homeitems.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/pages/main/views/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseService firebaseService = FirebaseService();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      final ref = _storage.ref().child(
          'users/${FirebaseAuth.instance.currentUser!.email.toString()}.jpg');
      await ref.putFile(_image!);
      final url = await ref.getDownloadURL();
      print('Image uploaded: $url');

      try {
        print("inside looop");
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.email.toString())
            .update({
          'userIMG': url,
        });
        print("Firestore doone");
        navigator!.pop(context);
        AlertDialog(
          content: Text("Image Uploaded Successfully"),
        );
      } catch (e) {
        navigator!.pop(context);
        AlertDialog(
          content: Text(e.toString()),
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> skip() async {
    return Get.to(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Add Profile Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: BoxConstraints(maxHeight: 400),
                child: _image == null
                    ? Text('No image selected.')
                    : Image.file(_image!),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: KAppColors.kButtonPrimary,
                minimumSize: Size(size.width / 2, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: skip,
              child: Text(
                "Skip",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

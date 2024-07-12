import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/pages/authentication/views/login_view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileImageM extends StatefulWidget {
  const ProfileImageM({super.key});

  @override
  _ProfileImageMState createState() => _ProfileImageMState();
}

class _ProfileImageMState extends State<ProfileImageM> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadImage();
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
        print("inside loop");
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.email.toString())
            .update({
          'userIMG': url,
        });
        print("Firestore done");

        Navigator.of(context).pop(); 
        // Dismiss the loading dialog
        Get.snackbar("Succss", "Image Uploaded Successfully. Please Login Now.");
                                Get.to(()=>const LoginScreen(),transition: Transition.cupertinoDialog,  duration: Duration(seconds: 1));
      } catch (e) {
        Navigator.of(context).pop(); // Dismiss the loading dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.toString()),
            );
          },
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Dismiss the loading dialog
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Profile Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: const Text("Please Select Profile Image"),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: KAppColors.kButtonPrimary,
                minimumSize: Size(size.width / 2.9, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: _pickImage,
              child: const Text(
                "Select Image and Upload",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
           
          ],
        ),
      ),
    );
  }
}

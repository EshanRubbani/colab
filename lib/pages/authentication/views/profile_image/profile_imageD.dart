import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/pages/authentication/views/login_view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileImageD extends StatefulWidget {
  const ProfileImageD({super.key});

  @override
  _ProfileImageDState createState() => _ProfileImageDState();
}

class _ProfileImageDState extends State<ProfileImageD> {
  
  File? _image;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  Uint8List? _imageBytes; // Use Uint8List for web image representation
  final ImagePicker _picker = ImagePicker();

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
      final ref = _storage.ref().child('users/${FirebaseAuth.instance.currentUser!.email}.jpg');
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
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({'userIMG': url});

      Get.back(); // Close the loading dialog
      Get.offAll(() => const LoginScreen()); // Navigate to LoginScreen
    } catch (e) {
      Get.back(); // Close dialog in case of error
      Get.snackbar("Error", e.toString()); // Show error using Get.snackbar
    }
  }


  Future<void> skip() async {
    return Get.to(const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Profile Image WEB')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: kIsWeb ? const Text("Please Select Profile Image") : Image.file(_image!),
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
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: KAppColors.kButtonPrimary,
                minimumSize: Size(size.width / 2.9, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: skip,
              child: const Text(
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

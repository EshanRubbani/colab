import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadModel {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(Function(File) onImagePicked) async {
    // Get image from user
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return "";

    // Convert XFile to File
    final File imageFile = File(pickedImage.path);

    // Upload image to Firebase Storage
    final Reference ref =
        _storage.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
    await ref.putFile(imageFile);

    // Get download URL
    final String downloadUrl = await ref.getDownloadURL();

    // Return download URL
    return downloadUrl;
  }
}

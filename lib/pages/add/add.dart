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
 


    final userIdentifier = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.phoneNumber!;

  final FirestoreService fireStoreService = FirestoreService();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController totalBackersController = TextEditingController();
  final TextEditingController itemImgController = TextEditingController();
  final UserImageHelper _userImageHelper = UserImageHelper();
   final TextEditingController descriptionController = TextEditingController();
  
  
 
  final List<String> items = [
    'Local Deal',
    'State-Wide Deal',
    'Country-Wide Deal',
    'Global Deal',
  ];
  final List<String> categories = [
    'Food',
    'Electronics',
    'Hobby',
    'Crafts',
    'Art',
    'Technology',
    'Jewelry',
    'Aquatics',
    'Home Improvement',
    'Remote control',
    'Automotive',
    'Clothing ',
  ];
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var posturl = "Select Item Image";
  Uint8List? _imageBytes; // Use Uint8List for web image representation
  String itemType = 'Product';
  String? selectedValue;
  String? selectedCategory;

  Widget _buildRadioButtons() {
    // Helper function for radio buttons
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

  Widget _categories() {
    return Container(
      width: 300,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            'Select Category',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: categories
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
          value: selectedCategory,
          onChanged: (String? value) {
            setState(() {
              selectedCategory = value;
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
    // Pick an image from the gallery
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    print("pickedFile: $pickedFile");

    if (pickedFile != null) {
      if (kIsWeb) {
        // If running on the web, read the image as bytes directly
        _imageBytes = await pickedFile.readAsBytes();
        print("bytes: $_imageBytes");
      } else {
        // If running on a mobile device, read the image file as bytes
        _imageBytes = await File(pickedFile.path).readAsBytes();
      }

      // Trigger a rebuild after image selection and upload the image
      setState(() {
        _uploadImage();
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageBytes == null) return;

    Get.dialog(const Center(
        child:
            CircularProgressIndicator())); // Use Get.dialog for better overlay

    try {
      final ref = _storage
          .ref()
          .child('posts/${DateTime.now().millisecondsSinceEpoch}.jpg');
      print("upload task beggining");
      // Upload task: Handles both web and mobile scenarios
      UploadTask uploadTask = kIsWeb
          ? ref.putData(_imageBytes!)
          : ref.putFile(File(await _picker
              .pickImage(source: ImageSource.gallery)
              .then((value) => value!.path)));

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

    return await fireStoreService.getUserProfileImage(userIdentifier);
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
    print(itemNameController.text);
    print(costController.text);
   
    print(totalBackersController.text);
    print(descriptionController.text);
    print(selectedValue);
    print(selectedCategory);
    print(posturl);

    if (itemNameController.text.isNotEmpty &&
        costController.text.isNotEmpty &&
        
         totalBackersController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
        selectedValue != null &&
        selectedCategory != null &&
        posturl != "Select Item Image") {
          print("inside try catch");
      String itemName = itemNameController.text;
      int cost = int.parse(costController.text);
      int totalbackers= int.parse(totalBackersController.text);
      
      String itemImg = posturl;
      String ownerDp = await _userImageHelper.getUserImage(userIdentifier);
      Timestamp timestamp = Timestamp.now();
      String scope = selectedValue!;
      String category = selectedCategory!;
      int itemPercent = (0/cost *100).toInt();
      String description = descriptionController.text;
      int charges = (cost/totalbackers).toInt();


      try {
        const Center(child: CircularProgressIndicator());

        

        // Create group first and get the groupId
        String groupId = await GroupFunctions().createGroup(
            itemName, [userIdentifier], itemImg);
        print(groupId);
        print("Calling set post");

        // Set post with groupId
        await fireStoreService.setPost(
          
          itemImg,
          itemName,
          userIdentifier,
          ownerDp,
          Timestamp.now(),
          0.toString(),
          cost.toString(),
          itemPercent.toString(),
          charges.toString(),
          selectedItemType,
          scope,
          groupId,
          category,
          description,
          totalbackers.toString(),
          0.toString(),
          


          );
        Navigator.pop(context);
        Get.snackbar('Success', 'Post Created Successfully',
            colorText: Colors.green);
        setState(() {
          itemNameController.clear();
         
          posturl = "Select Item Image";
        });
      } on FirebaseException catch (e) {
        Get.snackbar('Error', e.toString(), colorText: Colors.red);
      }
    } else {
      Get.snackbar('Error', 'Please Fill all Fields', colorText: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ResponsiveNess(
        mobile: _buildForMobile(context),
        desktop: _buildForDesktop(context),
      ),
    );
  }Widget _buildForDesktop(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Center(
    child: Container(
      // color: Colors.black,
      // Use a SizedBox to control the width and make it responsive
      // constraints: BoxConstraints(), // Adjust the multiplier as needed
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            // color: Colors.red,
            // Use a SizedBox to control the height and make it responsive
            constraints: BoxConstraints(minHeight: size.height -150 ,maxWidth: 350, minWidth: 350), // Adjust the multiplier as needed
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // const SizedBox(height: 10),
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
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: "Description of Item",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: costController,
                    decoration: InputDecoration(
                      hintText: "Total amount to be backed",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: totalBackersController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Total Backers Required",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
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
                  const SizedBox(height: 15),
                  _buildRadioButtons(),
                  _scope(),
                  _categories(), // Added _categories() here
                  const SizedBox(height: 15),
                  Center(
                    child: ButtonWidget(
                      size: size,
                      color: KAppColors.kButtonPrimary,
                      onTap: postItem,
                      text: "Post Item",
                    ),
                  ),
                  SizedBox(height: 20,), // Add some spacing
                  // Position the BottomNavm at the bottom center
                  
                ],
              ),
            ),
          ),
          Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 400,
                      child: BottomNavm(index: 2),
                    ),
                  ),
        ],
      ),
    ),
  );
}


  Widget _buildForMobile(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
           
            width: size.width / 1.2,
            height: size.height - 135,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
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
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: "Description of Item",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: costController,
                  decoration: InputDecoration(
                    hintText: "Total amount to be backed",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: totalBackersController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Total Backers Required",
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
                _categories(),
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

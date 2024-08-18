import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Collab/extras/common/common_button.dart';
import 'package:Collab/extras/utils/Helper/firestore.dart';
import 'package:Collab/extras/utils/Helper/groupchat/group.dart';
import 'package:Collab/extras/utils/Helper/user_model.dart';
import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:Collab/extras/utils/constant/navbarm.dart';
import 'package:Collab/extras/utils/res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    List<XFile>? _selectedFiles;
  List<String> imageUrls = [];

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
          activeColor: KAppColors.kPrimary,

          value: 'Product',
          groupValue: itemType,
          onChanged: (value) => setState(() => itemType = value!),
        ),
        const Text('Product'),
        Radio<String>(
          activeColor: KAppColors.kPrimary,
          
          value: 'Service',
          groupValue: itemType,
          onChanged: (value) => setState(() => itemType = value!),
        ),
        const Text('Service'),
        Radio<String>(
          activeColor: KAppColors.kPrimary,
          
          value: 'Need',
          groupValue: itemType,
          onChanged: (value) => setState(() => itemType = value!),
        ),
        const Text('Need'),
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
              fontSize: 16,
              fontFamily: "Poppins",
              color: KAppColors.kPrimary,
            ),
          ),
          items: items
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                          fontSize: 16,
              fontFamily: "Poppins",
              color: KAppColors.kPrimary,
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
                fontSize: 16,
              fontFamily: "Poppins",
              color: KAppColors.kPrimary,
            ),
          ),
          items: categories
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                          fontSize: 16,
              fontFamily: "Poppins",
              color: KAppColors.kPrimary,
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
            height: 30,
          ),
        ),
      ),
    );
  }

  Future<String?> ownerimage() async {
    return await fireStoreService.getUserProfileImage(userIdentifier);
  }

  /*-------------------------------Multiple Media Extension------------------------------------------------------------ */
    Future<void> _pickMultipleImages() async {
    List<XFile>? pickedFiles = await _picker.pickMultiImage(limit: 5);

    if (pickedFiles == null || pickedFiles.isEmpty) {
      print("No images selected");
      Get.snackbar("Error", "No images selected");
      return;
    }

    print("pickedFiles: $pickedFiles");

    setState(() {
      _selectedFiles = pickedFiles;
    });

    List<Uint8List> imageBytesList = [];

    for (var pickedFile in pickedFiles) {
      Uint8List bytes = await File(pickedFile.path).readAsBytes();
      imageBytesList.add(bytes);
    }

    await _uploadMultipleImages(imageBytesList);
  }

  Future<void> _uploadMultipleImages(List<Uint8List> imageBytesList) async {
    if (imageBytesList.isEmpty) return;

    Get.dialog(const Center(child:   SpinKitChasingDots(
      color: KAppColors.kPrimary,
      size: 80,
    )));

    try {
      for (var imageBytes in imageBytesList) {
        final ref = _storage
            .ref()
            .child('posts/${DateTime.now().millisecondsSinceEpoch}.jpg');

        UploadTask uploadTask = ref.putData(imageBytes);

        await uploadTask;
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
        print("Uploaded image URL: $url");
      }

      setState(() {
        print("All image URLs: $imageUrls");
      });

      Get.back();
    } catch (e) {
      Get.back();
      Get.snackbar("Error", e.toString());
    }
  }
      
  /* -----------------------------------------------------Multiple Media Extension----------------------------------------------- */

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
      selectedCategory != null
     ) {
    print("inside try catch");
    String itemName = itemNameController.text;
    int cost = int.parse(costController.text);
    int totalbackers = int.parse(totalBackersController.text);

    String itemImg = posturl;
    String ownerDp = await _userImageHelper.getUserImage(userIdentifier);
    Timestamp timestamp = Timestamp.now();
    String scope = selectedValue!;
    String category = selectedCategory!;
    int itemPercent = (0 / cost * 100).toInt();
    String description = descriptionController.text;
    int charges = (cost / totalbackers).ceil(); // Round up to the nearest integer

    print('Cost: $cost');
    print('Charges: $charges');
    print('Item Percent: $itemPercent');

    try {
      const Center(child: SpinKitChasingDots(
        color: KAppColors.kPrimary,
        size: 80,
      ));

      // Create group first and get the groupId
      String groupId = await GroupFunctions()
          .createGroup(itemName, [userIdentifier], imageUrls[0]);
      String username = await fireStoreService.getUsername(userIdentifier);
      print(groupId);
      print(username);
      print("Calling set post");

      // Set post with groupId
      await fireStoreService.setPost(
        imageUrls,
        itemName,
        username,
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
  }

  Widget _buildForDesktop(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              constraints: BoxConstraints(
                  minHeight: size.height - 150, maxWidth: 350, minWidth: 350),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    SizedBox(
                      height: 20,
                    ), // Add some spacing
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

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              
              width: size.width,
              height: size.height -180,
              child: Column(
                children: [
                   SizedBox(height: 10), 
                  Text("Create a New Post",style: TextStyle(color: KAppColors.kPrimary,fontFamily: "Poppins",fontSize: 20,fontWeight: FontWeight.w600),),
                   SizedBox(height: 10),   
                  Container(
                  
                    width: size.width / 1.2,
                    height: size.height - 650,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildformfields(),
                        const SizedBox(height: 10),
                        _buildRadioButtons(),
                        _scope(),
                        _categories(),
                       
                        
                      ],
                    ),
                    
                  ),
                   buildMedia(size),
                   SizedBox(height: 10),
                    Center(
                              child: ButtonWidget(
                                size: size /2,
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
    );
  }

  Container buildMedia(Size size) {
     return Container(
      width: size.width / 1.2,
      height: 295,
      // color: Colors.red,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await _pickMultipleImages();
            },
            child: Text("Select and Upload Images"),
          ),
          _selectedFiles != null
              ? Container(
                  color: Colors.grey.shade500.withOpacity(0.5),
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedFiles!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(File(_selectedFiles![index].path)),
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Column buildformfields() {
    return Column(
                children: [
                  TextFormField(
                    controller: itemNameController,
                    decoration: InputDecoration(
                      
                      labelText: "Post Name" ,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: KAppColors.kPrimary),
                        borderRadius: BorderRadius.circular(10.0),),
                      labelStyle: TextStyle(color: KAppColors.kPrimary),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: KAppColors.kPrimary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: descriptionController,
                     decoration: InputDecoration(
                      
                      labelText: "Post Description" ,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: KAppColors.kPrimary),
                        borderRadius: BorderRadius.circular(10.0),),
                      labelStyle: TextStyle(color: KAppColors.kPrimary),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: KAppColors.kPrimary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: costController,
                     keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      
                      labelText: "Cost(\$)" ,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: KAppColors.kPrimary),
                        borderRadius: BorderRadius.circular(10.0),),
                      labelStyle: TextStyle(color: KAppColors.kPrimary),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: KAppColors.kPrimary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: totalBackersController,
                    keyboardType: TextInputType.number,
                     decoration: InputDecoration(
                      
                      labelText: "No. of Backers" ,
                      
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: KAppColors.kPrimary),
                        borderRadius: BorderRadius.circular(10.0),),
                      labelStyle: TextStyle(color: KAppColors.kPrimary),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: KAppColors.kPrimary),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              );
  }
}

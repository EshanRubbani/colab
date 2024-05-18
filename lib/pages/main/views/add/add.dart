import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab/extras/common/common_button.dart';
import 'package:collab/extras/common/common_textfield.dart';
import 'package:collab/extras/utils/Helper/firestore.dart';
import 'package:collab/extras/utils/constant/colors.dart';
import 'package:collab/extras/utils/res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
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
        desktop: _buildForDesktop(),
      ),
    );
  }
}

Widget _buildForDesktop() {
  return Column();
}

Widget _buildForMobile(BuildContext context) {
  final size = MediaQuery.of(context).size;

  // Initialize Firestore
  final FireStore fireStore = FireStore();

  // Controllers
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController backedController = TextEditingController();
  final TextEditingController itemPercentController = TextEditingController();
  final TextEditingController itemImgController = TextEditingController();
  final TextEditingController ownerImgController = TextEditingController();

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
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void postItem() {
    // Only post if all data exist
    if (itemNameController.text.isNotEmpty &&
        backedController.text.isNotEmpty &&
        itemPercentController.text.isNotEmpty &&
        itemImgController.text.isNotEmpty &&
        ownerImgController.text.isNotEmpty) {
      String itemName = itemNameController.text;
      int backed = int.parse(backedController.text.toString());

      int itemPercent = int.parse(itemPercentController.text.toString());
      String ownerName = fireStore.user!.email.toString();
      String itemImg = itemImgController.text;
      String ownerDp = ownerImgController.text;

      try {
        fireStore.addPost(
            itemName, ownerName, backed, itemPercent, itemImg, ownerDp);
      } on FirebaseException catch (e) {
        genericErrorMessage(e.code);
      }
    }
  }

  return Padding(
    padding: const EdgeInsets.all(19.0),
    child: Column(
      children: [
        SizedBox(height: 30),
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
        SizedBox(height: 30),
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
        SizedBox(height: 30),
        TextFormField(
          controller: itemPercentController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "Item Percent",
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        SizedBox(height: 30),
        TextFormField(
          controller: itemImgController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "Item Image URL",
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        SizedBox(height: 30),
        TextFormField(
          controller: ownerImgController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "Owner Image URL",
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        SizedBox(height: 50),
        Center(
          child: ButtonWidget(
            size: size,
            color: KAppColors.kButtonPrimary,
            onTap: postItem,
            text: "Post Item",
          ),
        )
      ],
    ),
  );
}

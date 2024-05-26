import 'package:collab/extras/utils/constant/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
const MenuItem({ super.key });

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          //1st menu option
        Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        minimumSize: const Size(345, 55),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: (){},
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: Image.asset('assets/images/hat.png'),
          ),
          const SizedBox(width: 10),
          const Text(
            "All Group Members",
            style: TextStyle(color: KAppColors.kPrimary),
          ),
          const Spacer(),
          SizedBox(
            height: 20,
            width: 20,
            child: GestureDetector(
              child: const Icon(CupertinoIcons.forward),
              onTap: () {},
            ),
          ),
        ],
      ),
    ),
  ),
      
        const SizedBox(height: 10),

          //2nd menu option
          
          Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        minimumSize: const Size(345, 55),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: (){},
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: Image.asset('assets/images/hat.png'),
          ),
          const SizedBox(width: 10),
          const Text(
             "Male",
            style: TextStyle(color: KAppColors.kPrimary),
          ),
          const Spacer(),
          SizedBox(
            height: 20,
            width: 20,
            child: GestureDetector(
              child: const Icon(CupertinoIcons.forward),
              onTap: () {},
            ),
          ),
        ],
      ),
    ),
  ),
      

      const SizedBox(height: 10),
          //3rd menu option
          Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        minimumSize: const Size(345, 55),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: (){},
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: Image.asset("assets/images/hat.png"),
          ),
          const SizedBox(width: 10),
          const Text(
           "Female",
            style: TextStyle(color: KAppColors.kPrimary),
          ),
          const Spacer(),
          SizedBox(
            height: 20,
            width: 20,
            child: GestureDetector(
              child: const Icon(CupertinoIcons.forward),
              onTap: () {},
            ),
          ),
        ],
      ),
    ),
  )
          
        ],
      ),
    );
  }
}
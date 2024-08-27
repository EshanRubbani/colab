import 'package:Collab/extras/utils/constant/colors.dart';
import 'package:flutter/material.dart';
class SocailLoginWidget extends StatelessWidget {
  const SocailLoginWidget({
    super.key,
    required this.size,
    required this.path,
    required this.onTap,
  });

  final Size size;
  final String path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.9,
        height: 50,
        decoration: BoxDecoration(  
          color:  KAppColors.kSecondary,
         
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
        child: Image.asset('assets/icons/$path', width: 20.0, height: 20.0,),
      ),
    );
  }
}
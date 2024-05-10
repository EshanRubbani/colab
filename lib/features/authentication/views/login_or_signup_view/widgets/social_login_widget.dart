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
        width: double.infinity,
        height: size.height * 0.057,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
        child: Image.asset('assets/icons/$path', width: 20.0, height: 20.0,),
      ),
    );
  }
}
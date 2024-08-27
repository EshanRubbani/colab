import 'package:flutter/material.dart';
class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.size,
    required this.color,
    required this.onTap,
    required this.text,
    this.textColor = Colors.white,
  });

  final Size size;
  final Color color, textColor;
  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(size.width * 0.9, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: onTap, child: Text(text, style: TextStyle(color: textColor),),);
  }
}
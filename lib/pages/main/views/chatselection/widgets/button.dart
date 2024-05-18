import 'package:collab/extras/utils/constant/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final bool index;

  const MyButton({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  bool showContainer = true;
  Widget build(BuildContext context) {
    return showContainer
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              fit: StackFit.passthrough,
              children: [
                Container(
                  //width: 380,
                  constraints:
                      const BoxConstraints(minWidth: 380.0, minHeight: 60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: KAppColors.kPrimary,
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.3), // Adjust shadow color
                        spreadRadius: 3, // Adjust spread
                        blurRadius: 5, // Adjust blur
                        offset:
                            const Offset(0, 3), // Adjust offset for direction
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(KAppColors.kPrimary),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Type Message",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Inter",
                        ),
                      )),
                )
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

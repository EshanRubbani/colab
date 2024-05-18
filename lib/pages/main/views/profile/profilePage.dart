import 'package:collab/extras/utils/device/navbarm.dart';
import 'package:collab/extras/utils/res.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          ResponsiveNess(mobile: buildformobile(), desktop: buildfordesktop()),
    );
  }

  buildformobile() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          SizedBox(
            height: 240,
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavm(index: 4),
          )
        ],
      ),
    );
  }

  buildfordesktop() {
    return Column();
  }
}

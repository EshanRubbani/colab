// ignore_for_file: sized_box_for_whitespace, unused_local_variable

import 'package:Collab/extras/utils/constant/device_size.dart';
import 'package:Collab/extras/utils/res.dart';
import 'package:Collab/pages/discover/widget/discover_desktop.dart';
import 'package:Collab/pages/discover/widget/discover_mobile.dart';
import 'package:flutter/material.dart';
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {

  @override
  void initState() {
    super.initState();
    
    
  }


  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
     
      body: const Responsive(
        mobile: DiscoverMobile(),
        desktop: DiscoverDesktop(),
      ),
    );
  }
}
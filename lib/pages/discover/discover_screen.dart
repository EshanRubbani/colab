// ignore_for_file: sized_box_for_whitespace, unused_local_variable

import 'package:collab/extras/utils/res.dart';
import 'package:collab/pages/discover/widget/discover_desktop.dart';
import 'package:collab/pages/discover/widget/discover_mobile.dart';
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
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.white,
        foregroundColor: Colors.white,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        actions: const [],
      ),
      body: const ResponsiveNess(
        mobile: DiscoverMobile(),
        desktop: DiscoverDesktop(),
      ),
    );
  }
}
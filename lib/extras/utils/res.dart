// class KDeviceSize{
//   KDeviceSize._();
//
// }
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

class ResponsiveNess extends StatelessWidget {
  final Widget mobile;

  final Widget desktop;

  const ResponsiveNess({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  // // This isMobile, isTablet, isDesktop helep us later
  // static bool isMobile(BuildContext context) =>
  //     MediaQuery.of(context).size.width < 850;

  // static bool isDesktop(BuildContext context) =>
  //     MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    // If our width is more than 1100 then we consider it a desktop
    if (kIsWeb) {
      // Some web specific code there
      return desktop;
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      return mobile;
      // Some android/ios specific code
    } else {
      return mobile;
    }
  }
}

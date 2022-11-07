import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/Constants/Utils.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;
  const Responsive({Key? key, required this.mobile, required this.desktop})
      : super(key: key);
  static bool isMobile(BuildContext context) {
    return Utils(context).getsize().width < 950;
  }

  static bool isDesktop(BuildContext context) =>
      Utils(context).getsize().width >= 950;

  @override
  Widget build(BuildContext context) {
    var setsize = Utils(context).getsize();
    if (setsize.width >= 950) {
      return desktop;
    } else {
      return mobile;
    }
  }
}

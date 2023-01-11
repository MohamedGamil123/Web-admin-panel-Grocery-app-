import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/Widgets/customtext.dart';

class DrawerListTile extends StatelessWidget {
  String title;
  Function press;
  IconData icon;
  DrawerListTile(
      {required this.title, required this.press, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      onTap: () {
        press();
      },
      title: CustomText(
        text: title,
        color: Colors.black,
      ),
    );
  }
}

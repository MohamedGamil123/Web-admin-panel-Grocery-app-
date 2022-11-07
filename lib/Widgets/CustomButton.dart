import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/Widgets/customtext.dart';

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final String text;
  Function press;
  CustomButton(
      {required this.icon,
      required this.text,
      required this.backgroundColor,
      required this.press});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: CustomText(text: text),
      onPressed: () {
        press();
      },
      icon: Icon(icon),
      style: TextButton.styleFrom(backgroundColor: backgroundColor),
    );
  }
}

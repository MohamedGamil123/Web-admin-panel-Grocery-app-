import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/Controllers/MenuController.dart';
import 'package:grocery_admin_panel/Widgets/customtext.dart';
import 'package:grocery_admin_panel/Widgets/responsive.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  Function fct;
  String text;
  bool showtextfeild;
  Header({required this.fct, required this.text, required this.showtextfeild});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (Responsive.isMobile(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              fct();
            },
          ),
        if (Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.all(10),
            child: CustomText(
              color: Colors.green.shade800,
              text: text,
              istitle: true,
            ),
          ),
        if (Responsive.isDesktop(context))
          Spacer(
            flex: Responsive.isDesktop(context) ? 1 : 2,
          ),
        Expanded(
          child: showtextfeild
              ? TextField(
                  decoration: InputDecoration(
                      hintText: "Search",
                      fillColor: Colors.green.shade100,
                      filled: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, size: 25),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Colors.black))))
              : Container(),
        )
      ],
    );
  }
}

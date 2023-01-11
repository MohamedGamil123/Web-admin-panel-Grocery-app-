import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/Controllers/MenuController.dart';
import 'package:grocery_admin_panel/Widgets/DashboardScreen.dart';
import 'package:grocery_admin_panel/Widgets/SideMenu.dart';
import 'package:grocery_admin_panel/Widgets/responsive.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  static const String Mainid = "Mainid";
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldkey,
      drawer: const Sidemenu(),
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: Sidemenu(),
            ),
          const Expanded(
            flex: 5,
            child: DashBoardScreen(),
          )
        ],
      )),
    );
  }
}

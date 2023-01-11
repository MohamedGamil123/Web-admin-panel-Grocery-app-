import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/Screens/All_Orders.dart';
import 'package:grocery_admin_panel/Screens/All_products.dart';
import 'package:grocery_admin_panel/Screens/MainScreen.dart';
import 'package:grocery_admin_panel/Widgets/DrawerListTile.dart';

class Sidemenu extends StatefulWidget {
  const Sidemenu({super.key});

  @override
  State<Sidemenu> createState() => _SidemenuState();
}

class _SidemenuState extends State<Sidemenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
          child: Image.asset("assets/images/cart.png"),
        ),
        DrawerListTile(
          title: "Main",
          press: () {
            Navigator.of(context).pushReplacementNamed(MainScreen.Mainid);
          },
          icon: Icons.home,
        ),
        DrawerListTile(
          title: "View all products",
          press: () {
            Navigator.of(context)
                .pushReplacementNamed(AllProductsScreen.AllproId);
          },
          icon: Icons.store,
        ),
        DrawerListTile(
          title: "View all orders",
          press: () {
            Navigator.of(context)
                .pushReplacementNamed(All_Orders_Screen.OrderId);
          },
          icon: Icons.badge,
        ),
        DrawerListTile(
          title: "theme",
          press: () {},
          icon: Icons.dark_mode,
        ),
      ]),
    );
  }
}

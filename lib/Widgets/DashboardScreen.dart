import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/Constants/Utils.dart';
import 'package:grocery_admin_panel/Controllers/MenuController.dart';
import 'package:grocery_admin_panel/InnerScreens/AddProductScreen.dart';
import 'package:grocery_admin_panel/Screens/All_products.dart';
import 'package:grocery_admin_panel/Widgets/All_orders_Widget.dart';
import 'package:grocery_admin_panel/Widgets/CustomButton.dart';
import 'package:grocery_admin_panel/Widgets/Custom_Gridview_product.dart';
import 'package:grocery_admin_panel/Widgets/Header.dart';
import 'package:grocery_admin_panel/Widgets/Product_Widget.dart';
import 'package:grocery_admin_panel/Widgets/customtext.dart';
import 'package:grocery_admin_panel/Widgets/responsive.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var setsize = Utils(context).getsize();
    return SafeArea(
      child: SingleChildScrollView(
          controller: ScrollController(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Header(
                  fct: () {
                    context.read<MenuController>().controlDashBoardMenu();
                  },
                  text: "Dashboard",
                  showtextfeild: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomText(
                  text: "Latest products",
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        press: () {
                          Navigator.of(context)
                              .pushReplacementNamed(AllProductsScreen.AllproId);
                        },
                        text: "View all",
                        backgroundColor: Colors.orange.shade800,
                        icon: Icons.store,
                      ),
                      CustomButton(
                        press: () {
                          Navigator.of(context)
                              .pushReplacementNamed(AddProductScreen.addpro);
                        },
                        text: "Add products",
                        backgroundColor: Colors.orange.shade800,
                        icon: Icons.add,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Responsive(
                            desktop: Custom_gridview_product(isMain: true),
                            mobile: Custom_gridview_product(isMain: true),
                          ),
                          Divider(
                            height: 50,
                            thickness: 2,
                          ),
                          Responsive(
                            desktop: Custom_gridview_product(isMain: false),
                            mobile: Custom_gridview_product(isMain: false),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

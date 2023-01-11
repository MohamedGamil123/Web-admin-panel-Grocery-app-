import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/Controllers/MenuController.dart';
import 'package:grocery_admin_panel/Widgets/Custom_Gridview_product.dart';
import 'package:grocery_admin_panel/Widgets/Header.dart';
import 'package:grocery_admin_panel/Widgets/SideMenu.dart';
import 'package:grocery_admin_panel/Widgets/responsive.dart';
import 'package:provider/provider.dart';

class AllProductsScreen extends StatefulWidget {
  static const String AllproId = "AllproId";
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().gridScaffoldKey,
      drawer: const Sidemenu(),
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: Sidemenu(),
            ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
                controller: ScrollController(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Header(
                        fct: () {
                          context.read<MenuController>().controlProductMenu();
                        },
                        text: "All products",
                        showtextfeild: true,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Responsive(
                        desktop: Custom_gridview_product(isMain: false),
                        mobile: Custom_gridview_product(isMain: false),
                      )
                    ],
                  ),
                )),
          )
        ],
      )),
    );
  }
}

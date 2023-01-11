import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/Constants/Utils.dart';
import 'package:grocery_admin_panel/Controllers/MenuController.dart';
import 'package:grocery_admin_panel/Widgets/All_orders_Widget.dart';
import 'package:grocery_admin_panel/Widgets/Header.dart';
import 'package:grocery_admin_panel/Widgets/SideMenu.dart';
import 'package:grocery_admin_panel/Widgets/responsive.dart';
import 'package:provider/provider.dart';

class All_Orders_Screen extends StatefulWidget {
  static const String OrderId = "OrderId";
  const All_Orders_Screen({super.key});

  @override
  State<All_Orders_Screen> createState() => _All_Orders_ScreenState();
}

class _All_Orders_ScreenState extends State<All_Orders_Screen> {
  @override
  Widget build(BuildContext context) {
    var setsize = Utils(context).getsize();
    return Scaffold(
      key: context.read<MenuController>().orderScaffoldKey,
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
                child: Column(children: [
                  Header(
                    fct: () {
                      context.read<MenuController>().controlOrderMenu();
                    },
                    text: "All orders",
                    showtextfeild: true,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 20,
                        itemBuilder: (BuildContext context, int index) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            const Center(
                                child: CircularProgressIndicator(
                              color: Colors.orange,
                            ));
                          }
                          return ListView.builder(
                            itemCount:  4,
                            itemBuilder: (BuildContext context, int index) {
                              return All_Orders_Widget(
                               
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ]),
              ),
            ),
          )
        ],
      )),
    );
  }
}

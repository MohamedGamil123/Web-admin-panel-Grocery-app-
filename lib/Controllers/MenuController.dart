import 'package:flutter/material.dart';

class MenuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> gridScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> orderScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> addProScaffoldKey = GlobalKey<ScaffoldState>();

  void controlDashBoardMenu() {
    if (!scaffoldkey.currentState!.isDrawerOpen) {
      scaffoldkey.currentState!.openDrawer();
    }
  }

  void controlProductMenu() {
    if (!gridScaffoldKey.currentState!.isDrawerOpen) {
      gridScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlOrderMenu() {
    if (!orderScaffoldKey.currentState!.isDrawerOpen) {
      orderScaffoldKey.currentState!.openDrawer();
    }
  }

  void addproScaffoldkey() {
    if (!addProScaffoldKey.currentState!.isDrawerOpen) {
      addProScaffoldKey.currentState!.openDrawer();
    }
  }
}

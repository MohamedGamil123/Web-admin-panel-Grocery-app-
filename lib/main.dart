import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:grocery_admin_panel/Controllers/MenuController.dart';
import 'package:grocery_admin_panel/InnerScreens/AddProductScreen.dart';
import 'package:grocery_admin_panel/Screens/All_Orders.dart';
import 'package:grocery_admin_panel/Screens/All_products.dart';
import 'package:grocery_admin_panel/Screens/MainScreen.dart';
import 'package:grocery_admin_panel/localization/AppLocals.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCgq1JcJGs_714jrMkdO2eOKNBw4CigJ10",
      appId: "1:884469637888:web:2623017a8c2f2feb6e89e5",
      messagingSenderId: "G-LYGY1B1WEX",
      projectId: "groceryapp1-fc85e",
      storageBucket: "groceryapp1-fc85e.appspot.com",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _appinitialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _appinitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              for (var locale in supportedLocales) {
                if (deviceLocale != null &&
                    deviceLocale.languageCode == locale.languageCode) {
                  return deviceLocale;
                }
              }

              return supportedLocales.first;
            },
            home: const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            )),
          );
        } else if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
                body: Center(child: Text("there where something wrong"))),
          );
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => MenuController(),
              )
            ],
            child: MaterialApp(
              routes: {
                AllProductsScreen.AllproId: (context) =>
                    const AllProductsScreen(),
                MainScreen.Mainid: (context) => const MainScreen(),
                All_Orders_Screen.OrderId: (context) =>
                    const All_Orders_Screen(),
                AddProductScreen.addpro: (context) => const AddProductScreen(),
              },
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const MainScreen(),
            ),
          );
        }
      },
    );
  }
}
//flutter run -d chrome --web-renderer html
//for firestore photos runder
// flutter run --web-renderer html 
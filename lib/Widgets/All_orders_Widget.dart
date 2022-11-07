import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/Constants/Utils.dart';
import 'package:grocery_admin_panel/Widgets/customtext.dart';

class All_Orders_Widget extends StatelessWidget {
  const All_Orders_Widget({super.key});

  @override
  Widget build(BuildContext context) {
    var setsize = Utils(context).getsize();
    return InkWell(
      onTap:(){} ,
      child: Container(
          height: setsize.height * 0.2,
          width: setsize.width,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.white,
            elevation: 10,
            shadowColor: Colors.grey.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,vertical: 5
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/cat/Apple.png.png",
                    fit: BoxFit.fill,
                  ),
                  Column(
                    children: [
                      CustomText(
                        text: "12X For  " r"$" "55.5",
                      ),
                      CustomText(
                        text: "By",
                        color: Colors.cyan,
                      ),
                      CustomText(
                        text: "Customer name",
                        istitle: true,
                         titletextsize: 20,
                      ),
                      CustomText(
                        text: "24/9/2022",
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}

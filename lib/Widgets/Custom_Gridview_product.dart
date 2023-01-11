import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_admin_panel/Constants/Utils.dart';
import 'package:grocery_admin_panel/Widgets/Product_Widget.dart';

class Custom_gridview_product extends StatelessWidget {
  bool isMain;
  Custom_gridview_product({super.key, required this.isMain});

  @override
  Widget build(BuildContext context) {
    var setsize = Utils(context).getsize();
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.connectionState);
          print(snapshot.hasData);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.orange,
            ));
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: setsize.width < 770 ? 2 : 4,
                mainAxisSpacing: setsize.width < 770 ? 0 : 40,
                crossAxisSpacing: setsize.width < 770 ? 0 : 10,
                childAspectRatio: setsize.width < 770 ? 1.7 : 1.3),
            itemCount: isMain && snapshot.data!.docs.length > 4
                ? 4
                : snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductWidgwt(
                id: snapshot.data!.docs[index]["id"],
                title: snapshot.data!.docs[index]["title"],
                imageUrl: snapshot.data!.docs[index]["imageUrl"],
                productCategoryName: snapshot.data!.docs[index]
                    ["productCategoryName"],
                isonsale: snapshot.data!.docs[index]["isOnSale"],
                ispiece: snapshot.data!.docs[index]["isPiece"],
                saleprice: snapshot.data!.docs[index]["salePrice"],
                price: snapshot.data!.docs[index]["price"],
                amount: snapshot.data!.docs[index]["amount"],
                prodescription: snapshot.data!.docs[index]["description"],
                unit: snapshot.data!.docs[index]["Unit"],
              );
            },
          );
        });
  }
}

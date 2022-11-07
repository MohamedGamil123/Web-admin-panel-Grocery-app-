import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:grocery_admin_panel/Constants/Utils.dart';
import 'package:grocery_admin_panel/InnerScreens/EditProductScreen.dart';

import 'package:grocery_admin_panel/Widgets/customtext.dart';

class ProductWidgwt extends StatefulWidget {
  String? id;
  String title;
  String? productCategoryName;
  String? imageUrl;
  String price = "0";
  bool isonsale;
  bool ispiece;
  String saleprice;
  String amount;
  String prodescription;
  String unit;
  ProductWidgwt(
      {super.key,
      required this.id,
      required this.title,
      required this.productCategoryName,
      required this.imageUrl,
      required this.isonsale,
      required this.ispiece,
      required this.saleprice,
      required this.price,
      required this.amount,
      required this.prodescription,
      required this.unit});

  @override
  State<ProductWidgwt> createState() => _ProductWidgwtState();
}

class _ProductWidgwtState extends State<ProductWidgwt> {
  @override
  void initState() {
    print(widget.price.toString());
    print(widget.title.toString());

    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    var setsize = Utils(context).getsize();
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditProductScreen(
              id: widget.id.toString(),
              amount: widget.amount,
              imageurl: widget.imageUrl.toString(),
              tittle: widget.title,
              price: widget.price,
              saleprice: widget.saleprice,
              isonsale: widget.isonsale,
              ispiece: widget.ispiece,
              selecteditem: widget.productCategoryName.toString(),
              prodescription: widget.prodescription,
              unit: widget.unit,
            ),
          ));
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Colors.white,
                elevation: 10,
                shadowColor: Colors.grey.withOpacity(0.3),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PopupMenuButton(
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    onTap: () {},
                                    child: CustomText(
                                      text: "Edit",
                                      color: Colors.black,
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection("products")
                                          .doc(widget.id)
                                          .delete();
                                      FirebaseStorage.instance
                                          .ref(widget.imageUrl)
                                          .delete();
                                    },
                                    child: CustomText(
                                      text: "Delete",
                                      color: Colors.red,
                                    ),
                                  ),
                                ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: widget.title,
                              istitle: true,
                              titletextsize: 20,
                              color: Colors.grey.shade800,
                            ),
                            Row(
                              children: [
                                CustomText(
                                  text: widget.amount,
                                ),
                                CustomText(
                                  text: widget.ispiece ? " piece" : " KG",
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(children: [
                                CustomText(
                                  text: r"$"
                                      "${widget.isonsale ? widget.saleprice.toString() : widget.price.toString()}",
                                  color: Colors.green.shade500,
                                  istitle: true,
                                  titletextsize: 18,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Visibility(
                                  visible: widget.isonsale ? true : false,
                                  child: CustomText(
                                    text: r"$" "${widget.price.toString()}",
                                    lineThrough: true,
                                    color: Colors.grey.shade700,
                                  ),
                                )
                              ]),
                            ),
                            CustomText(
                              text: "23/9/2022",
                            ),
                          ],
                        )
                      ]),
                ),
              ),
            ),
            Positioned(
              right: setsize.width < 770 ? 20 : 10,
              top: setsize.width < 770 ? -40 : -40,
              child: Image(
                image: NetworkImage(widget.imageUrl!),
                height: setsize.width < 770
                    ? setsize.height * 0.2
                    : setsize.height * 0.18,
                width: setsize.width < 770
                    ? setsize.width * 0.2
                    : setsize.width * 0.1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
/*Image.network(
                "assets/images/cat/Apple.png.png",
                height: setsize.width < 770
                    ? setsize.height * 0.2
                    : setsize.height * 0.18,
                width: setsize.width < 770
                    ? setsize.width * 0.2
                    : setsize.width * 0.1,
              ),*/

              /* Future getProductFromFirestrore() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> getProduct =
          await FirebaseFirestore.instance
              .collection("products")
              .doc(widget.id)
              .get();

      if (getProduct != null) {
        _title = getProduct.get("title");
        _productCategoryName = getProduct.get("productCategoryName");
        _imageUrl = getProduct.get("imageUrl");
        print(_title);
        print("...................................");
        print(_imageUrl);
      } else {
        return AwesomeDialog(
          width: 500,
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'there where an error!',
          desc: 'there where an error!',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      AwesomeDialog(
        width: 500,
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'there where an error!',
        desc: '$e',
        btnOkOnPress: () {},
      ).show();
    }
  }*/

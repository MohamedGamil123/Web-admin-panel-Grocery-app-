import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:grocery_admin_panel/Constants/Utils.dart';
import 'package:grocery_admin_panel/Controllers/MenuController.dart';
import 'package:grocery_admin_panel/Screens/MainScreen.dart';
import 'package:grocery_admin_panel/Widgets/CustomButton.dart';
import 'package:grocery_admin_panel/Widgets/Header.dart';
import 'package:grocery_admin_panel/Widgets/LoadingWidget.dart';
import 'package:grocery_admin_panel/Widgets/SideMenu.dart';
import 'package:grocery_admin_panel/Widgets/customtext.dart';
import 'package:grocery_admin_panel/Widgets/responsive.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulWidget {
  static String addpro = "addpro";
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController pro_titleController = TextEditingController();
  TextEditingController price_Controller = TextEditingController();
  TextEditingController sale_price_Controller = TextEditingController();
  TextEditingController pro_desc_controller = TextEditingController();
  TextEditingController amount_controller = TextEditingController();
  String selecteditem = "الفواكة";
  bool isPeice = false;
  String selectedUnit = "Kg";
  File? pickimgfileMOb;
  Uint8List webImageURL = Uint8List(8);
  Reference? ref;
  String? imageURL;
  FilePickerResult? result;
  String? webimageURL;
  bool isLoading = false;
  bool isonsale = false;
  @override
  void dispose() {
    pro_titleController.dispose();
    price_Controller.dispose();
    pro_desc_controller.dispose();
    sale_price_Controller.dispose();
    amount_controller.dispose();
    super.dispose();
  }

  void clearForm() {
    pro_titleController.clear();
    price_Controller.clear();
    pro_desc_controller.clear();
    sale_price_Controller.clear();
    amount_controller.clear();
    setState(() {
      selecteditem = "Vegetables";
      isPeice = false;
      selectedUnit = "Kg";
      pickimgfileMOb = null;
      webImageURL = Uint8List(8);
      webimageURL = null;
      isonsale = false;
    });
  }

  Future pick_web_mobile_ImageURL() async {
    if (!kIsWeb) {
      ImagePicker picker = ImagePicker();
      XFile? pickeimage = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickeimage != null) {
        var p = File(pickeimage.path);
        setState(() {
          pickimgfileMOb = p;
        });
      } else {
        print("No image has been picked");
      }
    } else if (kIsWeb) {
      ImagePicker picker = ImagePicker();
      XFile? pickeimage = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickeimage != null) {
        var f = await pickeimage.readAsBytes();
        setState(() {
          webImageURL = f;
          pickimgfileMOb = File("a");
        });
      } else {
        print("No image has been picked");
      }
    } else {
      print("Something went wrong");
    }
  }

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final uuid = const Uuid().v4();

  void uploadProduct() async {
    if (pro_titleController.text.isNotEmpty &&
            price_Controller.text.isNotEmpty &&
            pro_desc_controller.text.isNotEmpty &&
            isonsale
        ? sale_price_Controller.text.isNotEmpty
        : sale_price_Controller.text.isEmpty &&
            amount_controller.text.isNotEmpty &&
            pickimgfileMOb != null) {
      FocusScope.of(context).unfocus();

      try {
        print(kIsWeb);

        setState(() {
          isLoading = true;
        });
        ref =
            FirebaseStorage.instance.ref("product images").child("${uuid}jpg");

        kIsWeb
            ? await ref?.putData(Uint8List.fromList(webImageURL))
            : await ref?.putFile(pickimgfileMOb!);
        imageURL = await ref!.getDownloadURL();
        print(imageURL);
        setState(() {
          webimageURL = imageURL;
        });
        await FirebaseFirestore.instance.collection("products").doc(uuid).set({
          "id": uuid,
          "title": pro_titleController.text,
          "description": pro_desc_controller.text,
          "price": price_Controller.text,
          "salePrice": sale_price_Controller.text,
          "amount": amount_controller.text,
          "imageUrl": webimageURL,
          "productCategoryName": selecteditem,
          "isOnSale": isonsale,
          "isPiece": isPeice,
          "Unit": selectedUnit,
          "createdAt": Timestamp.now()
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product uploaded successfully'),
          ),
        );
        clearForm();
        Navigator.of(context).pushReplacementNamed(MainScreen.Mainid);
      } on FirebaseException catch (e) {
        setState(() {
          isLoading = false;
        });
        AwesomeDialog(
          width: 500,
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'there where an error!',
          desc: '$e',
          btnOkOnPress: () {},
        ).show();
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
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      AwesomeDialog(
        width: 500,
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Data not completed!',
        desc: 'Please complete data',
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    var setsize = Utils(context).getsize();
    return Scaffold(
      key: context.read<MenuController>().addProScaffoldKey,
      drawer: const Sidemenu(),
      body: LoadingScreen(
        isLoading: isLoading,
        child: Row(children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: Sidemenu(),
            ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Header(
                      fct: () {
                        context.read<MenuController>().addproScaffoldkey();
                      },
                      text: 'Add product',
                      showtextfeild: false,
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 10,
                                spreadRadius: -5,
                                color: Colors.grey)
                          ]),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              child: CustomText(
                                text: "Product title ",
                                istitle: true,
                                titletextsize: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextField(
                                  controller: pro_titleController,
                                  decoration: InputDecoration(
                                    hintText: "Product title ",
                                    fillColor: Colors.green.shade100,
                                    filled: false,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.green)),
                                  )),
                            ),
                            CustomText(
                              text: "Product description ",
                              istitle: true,
                              titletextsize: 18,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  controller: pro_desc_controller,
                                  decoration: InputDecoration(
                                    hintText: "Product description ",
                                    fillColor: Colors.green.shade100,
                                    filled: false,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.black)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.green)),
                                  )),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: "Price in" r"$",
                                          istitle: true,
                                          titletextsize: 18,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10, right: 70),
                                          child: TextFormField(
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]'))
                                              ],
                                              controller: price_Controller,
                                              key: const ValueKey("price \$"),
                                              decoration: InputDecoration(
                                                hintText: "Price",
                                                fillColor:
                                                    Colors.green.shade100,
                                                filled: false,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.black)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .green)),
                                              )),
                                        ),
                                        Row(
                                          children: [
                                            CustomText(
                                              text: "Product on sale",
                                              istitle: true,
                                              titletextsize: 18,
                                            ),
                                            Checkbox(
                                              value: isonsale,
                                              onChanged: (value) {
                                                setState(() {
                                                  isonsale = value!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: isonsale ? true : false,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10, right: 70),
                                            child: TextFormField(
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9.]'))
                                                ],
                                                controller:
                                                    sale_price_Controller,
                                                key: const ValueKey(
                                                    "Sale price \$"),
                                                decoration: InputDecoration(
                                                  hintText: "Sale price",
                                                  fillColor:
                                                      Colors.green.shade100,
                                                  filled: false,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Colors
                                                                  .black)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .green)),
                                                )),
                                          ),
                                        ),
                                        CustomText(
                                          text: "Product category",
                                          istitle: true,
                                          titletextsize: 18,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 1),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                                hint: CustomText(
                                                    text: "Select item"),
                                                value: selecteditem,
                                                onChanged: (val) {
                                                  setState(() {
                                                    selecteditem = val!;
                                                  });
                                                  print(selecteditem);
                                                },
                                                items: [
                                                  DropdownMenuItem(
                                                    value: "الخضروات",
                                                    child: CustomText(
                                                        text: "الخضروات"),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "الفواكة",
                                                    child: CustomText(
                                                        text: "الفواكة"),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "البقوليات",
                                                    child: CustomText(
                                                        text: "البقوليات"),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "المكسرات",
                                                    child: CustomText(
                                                        text: "المكسرات"),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "الأعشاب",
                                                    child: CustomText(
                                                        text: "الأعشاب"),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: "البهارات والتوابل",
                                                    child: CustomText(
                                                        text: "البهارات والتوابل"),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                        CustomText(
                                          text: "Measeure unit",
                                          istitle: true,
                                          titletextsize: 18,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  CustomText(
                                                    text: "Kg",
                                                  ),
                                                  Radio<String>(
                                                    activeColor: Colors.green,
                                                    value: "Kg",
                                                    groupValue: selectedUnit,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        selectedUnit = val!;
                                                        isPeice = false;
                                                      });
                                                      print(selectedUnit);
                                                      print(isPeice);
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  CustomText(
                                                    text: "Piece",
                                                  ),
                                                  Radio<String>(
                                                    activeColor: Colors.green,
                                                    value: "Piece",
                                                    groupValue: selectedUnit,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        selectedUnit = val!;
                                                        isPeice = true;
                                                      });
                                                      print(selectedUnit);
                                                      print(isPeice);
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10, right: 70),
                                          child: TextFormField(
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]'))
                                              ],
                                              controller: amount_controller,
                                              key: const ValueKey("Amount"),
                                              decoration: InputDecoration(
                                                hintText: "Amount",
                                                fillColor:
                                                    Colors.green.shade100,
                                                filled: false,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.black)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .green)),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: pickimgfileMOb == null
                                      ? DottedBorder(
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(10),
                                          padding: const EdgeInsets.all(6),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            child: SizedBox(
                                              height:
                                                  Responsive.isDesktop(context)
                                                      ? setsize.width * 0.25
                                                      : setsize.width * 0.4,
                                              width:
                                                  Responsive.isDesktop(context)
                                                      ? setsize.width * 0.25
                                                      : setsize.width * 0.4,
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.photo,
                                                      size: setsize.width * 0.1,
                                                      color: Colors.grey,
                                                    ),
                                                    CustomText(
                                                      text:
                                                          "Drop your image here or select ",
                                                    ),
                                                    TextButton(
                                                      child: CustomText(
                                                        text: "Choose an image",
                                                        color: Colors.blue,
                                                      ),
                                                      onPressed: () async {
                                                        pick_web_mobile_ImageURL();
                                                      },
                                                    )
                                                  ]),
                                            ),
                                          ),
                                        )
                                      : kIsWeb
                                          ? Image.memory(
                                              webImageURL,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.file(
                                              pickimgfileMOb!,
                                              fit: BoxFit.fill,
                                            ),
                                )),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            child: CustomText(
                                              text: "Clear photo",
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              pickimgfileMOb != null
                                                  ? AwesomeDialog(
                                                      context: context,
                                                      dialogType:
                                                          DialogType.warning,
                                                      width:
                                                          setsize.width * 0.3,
                                                      buttonsBorderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(10),
                                                      ),
                                                      dismissOnTouchOutside:
                                                          true,
                                                      dismissOnBackKeyPress:
                                                          true,
                                                      headerAnimationLoop:
                                                          false,
                                                      animType:
                                                          AnimType.bottomSlide,
                                                      title: 'Clear photo ?',
                                                      desc:
                                                          'Selected photo will be cleared!',
                                                      showCloseIcon: true,
                                                      btnCancelOnPress: () {},
                                                      btnOkOnPress: () {
                                                        setState(() {
                                                          pickimgfileMOb = null;
                                                          webImageURL =
                                                              Uint8List(8);
                                                        });
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                ' Photo cleared successfully'),
                                                          ),
                                                        );
                                                      },
                                                    ).show()
                                                  : ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'No photo picked ,choose one'),
                                                      ),
                                                    );
                                            },
                                          ),
                                        ]),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomButton(
                                  text: "Clear all form data",
                                  icon: Icons.warning,
                                  press: () {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      width: setsize.width * 0.3,
                                      buttonsBorderRadius:
                                          const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      dismissOnTouchOutside: true,
                                      dismissOnBackKeyPress: true,
                                      headerAnimationLoop: false,
                                      animType: AnimType.bottomSlide,
                                      title: 'Clear form ?',
                                      desc:
                                          'Selected data and photo will be cleared!',
                                      showCloseIcon: true,
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {
                                        clearForm();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'All data and photo cleared successfully'),
                                          ),
                                        );
                                      },
                                    ).show();
                                  },
                                  backgroundColor: Colors.red,
                                ),
                                CustomButton(
                                  text: "Upload",
                                  icon: Icons.upload,
                                  press: () async {
                                    uploadProduct();
                                  },
                                  backgroundColor: Colors.green,
                                )
                              ],
                            )
                          ]),
                    ),
                  ],
                ),
              )),
            ),
          )
        ]),
      ),
    );
  }
}



   /*Uint8List? uploadfile = result!.files.single.bytes;

        Reference refrence =
            FirebaseStorage.instance.ref("product image").child(uuid);
        //upload to firestore
        final UploadTask uploadtask = refrence.putData(uploadfile!);
        // get imgage url from firestore after upload finish
        uploadtask.whenComplete(
          () async {
            setState(() {
              isLoading = true;
            });
            imageURL = await uploadtask.snapshot.ref.getDownloadURL();
            setState(() {
              webimageURL = imageURL;
            });
            print("........URL    $webimageURL  ...............URL");
            await FirebaseFirestore.instance
                .collection("products")
                .doc(uuid)
                .set({
              "id": uuid,
              "title": pro_titleController.text,
              "price": price_Controller.text,
              "salePrice": 0.4,
              "imageUrl": imageURL,
              "productCategoryName": selecteditem,
              "isOnSale": false,
              "isPiece": isPeice,
              "createdAt": Timestamp.now()
            });
            print("firestor data sucsess......");

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(milliseconds: 2000),
              content: Row(
                children: [
                  CustomText(
                    text: "Product uploaded successfully",
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                ],
              ),
            ));
            setState(() {
              clearForm();
            });
            setState(() {
              isLoading = false;
            });
          },*/

          
  /*void _pickWebimage() async {
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
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


/*void _uploadWebimage() async {
    if (result != null) {
      try {
        Uint8List? uploadfile = result!.files.single.bytes;
        Reference refrence =
            FirebaseStorage.instance.ref("product image").child(uuid);
        //upload to firestore
        final UploadTask uploadtask = refrence.putData(uploadfile!);
        // get imgage url from firestore after upload finish
        uploadtask.whenComplete(
          () async {
            String webimageURL = await uploadtask.snapshot.ref.getDownloadURL();
            print("$webimageURL");
          },
        );
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
    }
  }*/


/*uploadimage() async {
    if (pickimgfileMOb != null) {
      try {
        setState(() {
          isLoading = true;
        });
        ref =
            FirebaseStorage.instance.ref("product images").child(uuid + "jpg");

        kIsWeb
            ? await ref?.putFile(pickimgfileMOb!)
            : await ref?.putData(webImageURL);

        imageURL = await ref!.getDownloadURL();
        print(imageURL);
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
    }
  }*/
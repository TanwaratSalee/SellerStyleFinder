// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:seller_finalproject/views/products_screen/component/product_images.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';

class EditProduct extends StatefulWidget {
  final Map<String, dynamic> productData;
  final String documentId;

  const EditProduct({
    Key? key,
    required this.productData,
    required this.documentId, 
  }) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late ProductsController controller;
  
  @override
  void initState() {
    super.initState();
    controller = Get.find<ProductsController>();
    controller.setupProductData(widget.productData);
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: const Text("Edit Product").text.size(24).fontFamily(medium).make(),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: primaryApp)
                : TextButton(
                    onPressed: () async {
                      if (controller.isDataComplete()) {
                        controller.isloading(true);
                        await controller.uploadImages();
                        await controller.updateProduct(context, widget.documentId);
                        controller.resetForm();
                        Get.back();
                        controller.isloading(false);
                        VxToast.show(context, msg: "Product saved successfully.");
                      } else {
                        VxToast.show(context, msg: "Please fill in all required fields.");
                      }
                    },
                    child: const Text(save).text.fontFamily(medium).size(18).make(),
                  ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Choose product images")
                    .text
                    .size(16)
                    .color(greyColor)
                    .fontFamily(medium)
                    .make(),
                15.heightBox,
                Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      (controller.pImagesList.length / 3).ceil(),
                      (row) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(
                            3,
                            (col) {
                              int index = row * 3 + col;
                              if (index < controller.pImagesList.length && controller.pImagesList[index] != null) {
                                return Stack(
                                  children: [
                                    controller.pImagesList[index] is File
                                        ? Image.file(
                                            controller.pImagesList[index],
                                            width: 100,
                                          )
                                        : Image.network(
                                            controller.pImagesList[index],
                                            width: 100,
                                          ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          controller.removeImage(index);
                                        },
                                      ),
                                    ),
                                  ],
                                ).onTap(() {
                                  controller.pickImage(index, context);
                                });
                              } else {
                                return productImages(label: "${index + 1}").onTap(() {
                                  controller.pickImage(index, context);
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                25.heightBox,
                customTextFieldInput(
                  // hint: "Name of product",
                  heading: "Name of product",
                  controller: controller.pnameController,
                ),
                15.heightBox,
                customTextFieldInput(
                  // hint: "About this product",
                  heading: "About product",
                  controller: controller.pabproductController,
                ),
                15.heightBox,
                customTextFieldInput(
                  // hint: "Description this Product",
                  heading: "Description",
                  isDesc: true,
                  controller: controller.pdescController,
                ),
                15.heightBox,
                customTextFieldInput(
                  // hint: "Size & Fit",
                  heading: "Size & Fit",
                  isDesc: true,
                  controller: controller.psizeController,
                ),
                15.heightBox,
                customTextFieldInput(
                  // hint: "15,000.00 Bath",
                  heading: "Price",
                  controller: controller.ppriceController,
                   keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                15.heightBox,
                customTextFieldInput(
                  // hint: "20",
                  heading: "Quantity",
                  controller: controller.pquantityController,
                   keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                15.heightBox,
               const Text("Collection")
                        .text
                        .size(16)
                        .color(blackColor)
                        .fontFamily(medium)
                        .make(),
                    3.heightBox,
                    Center(
                      child: Obx(
                        () => Wrap(
                          spacing: 6,
                          runSpacing: 8,
                          children: controller.collectionList.map((collection) {
                            bool isSelected = controller.selectedCollection
                                .contains(collection);
                            return GestureDetector(
                                onTap: () {
                                  if (isSelected) {
                                    controller.selectedCollection
                                        .remove(collection);
                                  } else {
                                    controller.selectedCollection
                                        .add(collection);
                                  }
                                },
                                child: SizedBox(
                                  width: 110,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? thinPrimaryApp
                                          : whiteColor,
                                      border: Border.all(
                                        color:
                                            isSelected ? primaryApp : greyLine,
                                        width: isSelected ? 2 : 1.3,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      capitalize(collection),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily:
                                            isSelected ? semiBold : regular,
                                        fontSize: 14,
                                        color:
                                            isSelected ? primaryApp : greyColor,
                                      ),
                                    ),
                                  ),
                                ));
                          }).toList(),
                        ),
                      ),
                    ),
                    10.heightBox,
                    const Text("Type of product")
                        .text
                        .size(16)
                        .color(blackColor)
                        .fontFamily(medium)
                        .make(),
                    10.heightBox,
                    Center(
                      child: Obx(
                        () => Wrap(
                          spacing: 6,
                          runSpacing: 1,
                          children:
                              controller.subcollectionList.map((subcollection) {
                            bool isSelected =
                                controller.selectedSubcollection.value ==
                                    subcollection;
                            return SizedBox(
                              width: 165,
                              child: ChoiceChip(
                                showCheckmark: false,
                                label: Center(
                                  child: Text(
                                    capitalize(subcollection),
                                    style: TextStyle(
                                      fontFamily:
                                          isSelected ? semiBold : regular,
                                      fontSize: 14,
                                      color:
                                          isSelected ? primaryApp : greyColor,
                                    ),
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    controller.selectedSubcollection.value =
                                        subcollection;
                                  }
                                },
                                selectedColor: thinPrimaryApp,
                                backgroundColor: whiteColor,
                                side: isSelected
                                    ? const BorderSide(
                                        color: primaryApp, width: 2)
                                    : const BorderSide(
                                        color: greyLine, width: 1.3),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    10.heightBox,
                    const Text("Suitable for gender")
                        .text
                        .size(16)
                        .color(blackColor)
                        .fontFamily(medium)
                        .make(),
                    10.heightBox,
                    Center(
                      child: Obx(
                        () => Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: controller.genderList.map((gender) {
                            bool isSelected =
                                controller.selectedGender.value == gender;
                            return Container(
                              width: 110,
                              child: ChoiceChip(
                                showCheckmark: false,
                                label: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    capitalize(gender),
                                    style: TextStyle(
                                      fontFamily:
                                          isSelected ? semiBold : regular,
                                      fontSize: 14,
                                      color:
                                          isSelected ? primaryApp : greyColor,
                                    ),
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    controller.selectedGender.value = gender;
                                  }
                                },
                                selectedColor: thinPrimaryApp,
                                backgroundColor: whiteColor,
                                side: isSelected
                                    ? const BorderSide(
                                        color: primaryApp, width: 2)
                                    : const BorderSide(
                                        color: greyLine, width: 1.3),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    15.heightBox,
                    const Text("Size of product")
                        .text
                        .size(16)
                        .color(blackColor)
                        .fontFamily(medium)
                        .make(),
                    8.heightBox,
                    Center(
                      child: Obx(
                        () => Wrap(
                          spacing: 8,
                          runSpacing: 1,
                          children: controller.sizesList.map((size) {
                            bool isSelected =
                                controller.selectedSizes.contains(size);
                            return SizedBox(
                              width: 100,
                              child: ChoiceChip(
                                showCheckmark: false,
                                label: Center(
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      fontFamily:
                                          isSelected ? semiBold : regular,
                                      fontSize: 14,
                                      color:
                                          isSelected ? primaryApp : greyColor,
                                    ),
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    if (!controller.selectedSizes
                                        .contains(size)) {
                                      controller.selectedSizes.add(size);
                                    }
                                  } else {
                                    controller.selectedSizes.remove(size);
                                  }
                                },
                                selectedColor: thinPrimaryApp,
                                backgroundColor: whiteColor,
                                side: isSelected
                                    ? const BorderSide(
                                        color: primaryApp, width: 2)
                                    : const BorderSide(
                                        color: greyLine, width: 1.3),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    15.heightBox,
                    const Text("Choose product colors")
                        .text
                        .size(16)
                        .color(blackColor)
                        .fontFamily(medium)
                        .make(),
                    const SizedBox(height: 8),
                    Center(
                      child: Obx(
                        () => Wrap(
                          spacing: 25,
                          runSpacing: 15,
                          children: List.generate(
                            controller.allColors.length,
                            (index) => GestureDetector(
                              onTap: () {
                                if (controller.selectedColorIndexes
                                    .contains(index)) {
                                  controller.selectedColorIndexes.remove(index);
                                } else {
                                  controller.selectedColorIndexes.add(index);
                                }
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: controller.allColors[index]['color'],
                                  border: Border.all(
                                    color: controller.selectedColorIndexes
                                            .contains(index)
                                        ? primaryApp
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: controller.selectedColorIndexes
                                          .contains(index)
                                      ? Icon(
                                          Icons.done,
                                          color: controller.allColors[index]
                                                      ['color'] ==
                                                  whiteColor
                                              ? blackColor
                                              : whiteColor,
                                        )
                                      : const SizedBox(),
                                ),
                              ).box.border(color: greyLine).roundedSM.make(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    15.heightBox,
                    const Text("Show mix and match")
                        .text
                        .size(16)
                        .color(blackColor)
                        .fontFamily(medium)
                        .make(),                    
                        8.heightBox,

                    Center(
                      child: Obx(() => Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                controller.mixandmatchList.map((mixandmatch) {
                              bool isSelected =
                                  controller.selectedMixandmatch.value ==
                                      mixandmatch;
                              return Container(
                                child: ChoiceChip(
                                  showCheckmark: false,
                                  label: Container(
                                    width: 75,
                                    alignment: Alignment.center,
                                    child: Text(
                                      capitalize(mixandmatch),
                                      style: TextStyle(
                                        color:
                                            isSelected ? primaryApp : greyColor,
                                        fontFamily:
                                            isSelected ? semiBold : regular,
                                      ),
                                    ).text.size(14).make(),
                                  ),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      controller.selectedMixandmatch.value =
                                          mixandmatch;
                                    }
                                  },
                                  selectedColor: thinPrimaryApp,
                                  backgroundColor: whiteColor,
                                  side: isSelected
                                      ? const BorderSide(
                                          color: primaryApp, width: 2)
                                      : const BorderSide(color: greyLine),
                                ),
                              );
                            }).toList(),
                          )),
                    ),
                  
                10.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

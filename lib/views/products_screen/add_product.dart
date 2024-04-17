import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:seller_finalproject/views/products_screen/component/product_dropdown.dart';
import 'package:seller_finalproject/views/products_screen/component/product_images.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';
import 'package:seller_finalproject/views/widgets/text_style.dart';

import 'package:get/get.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();

    final List<Map<String, dynamic>> allColors = [
      {'name': 'Black', 'color': Colors.black},
      {'name': 'Grey', 'color': Colors.grey},
      {'name': 'White', 'color': Colors.white},
      {'name': 'Purple', 'color': Colors.purple},
      {'name': 'Deep Purple', 'color': Colors.deepPurple},
      {'name': 'Blue', 'color': Colors.lightBlue},
      {'name': 'Blue', 'color': Color.fromARGB(255, 36, 135, 216)},
      {'name': 'Blue Grey', 'color': Colors.blueGrey},
      {'name': 'Green', 'color': Color.fromARGB(255, 17, 82, 50)},
      {'name': 'Green', 'color': Colors.green},
      {'name': 'Green Accent', 'color': Colors.greenAccent},
      {'name': 'Yellow', 'color': Colors.yellow},
      {'name': 'Orange', 'color': Colors.orange},
      {'name': 'Red', 'color': Colors.red},
      {'name': 'Red Accent', 'color': Color.fromARGB(255, 237, 101, 146)},
    ];

    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: Text("Add Product").text.size(24).fontFamily(medium).make(),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: primaryApp)
                : TextButton(
                    onPressed: () async {
                      if (controller.isDataComplete()) {
                        controller.isloading(true);
                        await controller.uploadImages();
                        await controller.uploadProduct(context);
                        controller
                            .resetForm(); // Reset form fields after the upload
                        Get.back(); // Optionally close the screen if needed
                        controller.isloading(false);
                        VxToast.show(context,
                            msg: "Product saved successfully.");
                      } else {
                        VxToast.show(context,
                            msg: "Please fill in all required fields.");
                      }
                    },
                    child: Text(save).text.fontFamily(medium).size(18).make())
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Choose product images")
                    .text
                    .size(16)
                    .color(greyDark1)
                    .fontFamily(medium)
                    .make(),
                15.heightBox,
                Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceAround, // This ensures space around rows
                    children: List.generate(
                      3,
                      (row) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7.0), // Adds space around each row
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceAround, // This ensures space around each image in a row
                          children: List.generate(
                            3,
                            (col) {
                              int index = row * 3 + col;
                              return Padding(
                                padding: const EdgeInsets.all(
                                    2.0), // Adds space around each image
                                child: controller.pImagesList[index] != null
                                    ? Image.file(
                                        controller.pImagesList[index],
                                        width: 100,
                                      ).onTap(() {
                                        controller.pickImage(index, context);
                                      })
                                    : productImages(label: "${index + 1}")
                                        .onTap(() {
                                        controller.pickImage(index, context);
                                      }),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                25.heightBox,
                customTextField(
                  hint: "Name of product",
                  label: "Name of product",
                  controller: controller.pnameController,
                ),
                15.heightBox,
                customTextField(
                    hint: "About this product",
                    label: "About product",
                    controller: controller.pabproductController),
                15.heightBox,
                customTextField(
                    hint: "Description this Product",
                    label: "Description",
                    isDesc: true,
                    controller: controller.pdescController),
                15.heightBox,
                customTextField(
                    hint: "Size & Fit",
                    label: "Size & Fit",
                    isDesc: true,
                    controller: controller.psizeController),
                15.heightBox,
                customTextField(
                    hint: "15,000.00 Bath",
                    label: "Price",
                    controller: controller.ppriceController),
                15.heightBox,
                customTextField(
                    hint: "20",
                    label: "Quantity",
                    controller: controller.pquantityController),
                15.heightBox,
                productDropdown("Collection", controller.collectionsList,
                    controller.collectionsvalue, controller),
                15.heightBox,
                productDropdown("Subcollection", controller.subcollectionList,
                    controller.subcollectionvalue, controller),
                20.heightBox,
                Text("Choose product colors")
                    .text
                    .size(16)
                    .color(greyDark1)
                    .fontFamily(medium)
                    .make(),
                15.heightBox,
                Obx(
                  () => Wrap(
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children: List.generate(
                      allColors.length,
                      (index) => Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: greyColor),
                              color: allColors[index]['color'] as Color,
                            ),
                            child: InkWell(
                              onTap: () {
                                final selected = controller.selectedColorIndexes
                                    .contains(index);
                                if (selected) {
                                  controller.removeSelectedColorIndex(index);
                                } else {
                                  controller.addSelectedColorIndex(index);
                                }
                              },
                            ),
                          ).box.margin(EdgeInsets.all(8)).make(),
                          if (controller.selectedColorIndexes.contains(index))
                            Icon(
                              Icons.done,
                              color: allColors[index]['color'] == Colors.white
                                  ? blackColor
                                  : whiteColor,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

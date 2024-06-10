import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:seller_finalproject/views/products_screen/component/product_images.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();
    controller.resetForm();
    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title:
              const Text("Add Product").text.size(24).fontFamily(medium).make(),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: primaryApp)
                : TextButton(
                    onPressed: () async {
                      if (controller.isDataComplete()) {
                        controller.isloading(true);
                        await controller.uploadImages();
                        await controller.uploadProduct(context);
                        Get.back();
                        controller.isloading(false);
                        VxToast.show(context,
                            msg: "Product saved successfully.");
                        print(controller.productId);
                      } else {
                        VxToast.show(context,
                            msg: "Please fill in all required fields.");
                      }
                    },
                    child: const Text(save)
                        .text
                        .fontFamily(medium)
                        .size(18)
                        .make())
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Choose product images")
                    .text
                    .size(16)
                    .color(blackColor)
                    .fontFamily(medium)
                    .make(),
                10.heightBox,
                Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      3,
                      (row) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(
                            3,
                            (col) {
                              int index = row * 3 + col;
                              return Padding(
                                padding: const EdgeInsets.all(2),
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
                10.heightBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTextFieldInput(
                      heading: "Name of product",
                      controller: controller.pnameController,
                    ),
                    10.heightBox,
                    customTextFieldInput(
                        // hint: "About this product",
                        heading: "About product",
                        controller: controller.pabproductController),
                    10.heightBox,
                    customTextFieldInput(
                        // hint: "Description this Product",
                        heading: "Description",
                        isDesc: true,
                        controller: controller.pdescController),
                    10.heightBox,
                    customTextFieldInput(
                        // hint: "Size & Fit",
                        heading: "Size & Fit",
                        isDesc: true,
                        controller: controller.psizeController),
                    10.heightBox,
                    customTextFieldInput(
                      heading: "Price",
                      controller: controller.ppriceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    10.heightBox,
                    customTextFieldInput(
                      heading: "Quantity",
                      controller: controller.pquantityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    10.heightBox,
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
                                    width: 70,
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
                    )
                  ],
                ).paddingSymmetric(horizontal: 16),
                100.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

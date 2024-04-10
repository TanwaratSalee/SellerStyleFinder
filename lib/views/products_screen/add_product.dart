import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:seller_finalproject/views/products_screen/component/product_dropdown.dart';
import 'package:seller_finalproject/views/products_screen/component/product_images.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';
import 'package:seller_finalproject/views/widgets/text_style.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: boldText(text: "Add Product", color: fontGreyDark, size: 25.0),
          actions: [
            controller.isloading.value
                ? loadingIndcator(circleColor: fontLightGrey)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
                      await controller.uploadImages();
                      await controller.uploadProduct(context);
                      Get.back();
                    },
                    child: boldText(text: save, color: fontGrey))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                boldText(text: "Add your images product ", color: fontGrey),
                20.heightBox,
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        1,
                        (index) => controller.pImagesList[index] != null
                            ? Image.file(
                                controller.pImagesList[index],
                                width: 100,
                              ).onTap(() {
                                controller.pickImage(index, context);
                              })
                            : InkWell(
                                onTap: () {
                                  controller.pickImage(index, context);
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[
                                        200], // สามารถปรับเป็นสีที่ต้องการ
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(
                                        8), // ปรับให้เข้ากับสไตล์ UI ของคุณ
                                  ),
                                  child: Icon(
                                    Icons
                                        .camera_alt, // เปลี่ยนเป็นไอคอนกล้องถ่ายรูป
                                    size: 50, // ปรับขนาดไอคอนตามความต้องการ
                                    color:
                                        Colors.grey, // สามารถปรับเปลี่ยนสีไอคอน
                                  ),
                                ),
                              ),
                      ),
                    )),

                30.heightBox,
                customTextField(
                    hint: "eg. BMW",
                    label: "Product name",
                    controller: controller.pnameController),
                30.heightBox,
                customTextField(
                    hint: "eg. about",
                    label: "About product",
                    controller: controller.pabproductController),
                30.heightBox,
                customTextField(
                    hint: "eg. Nice Product",
                    label: "Description",
                    isDesc: true,
                    controller: controller.pdescController),
                30.heightBox,
                productDropdown("Collection", controller.collectionsList,
                    controller.collectionsvalue, controller),
                30.heightBox,
                productDropdown("Type of product", controller.typepfproductList,
                    controller.typeofproductvalue, controller),
                30.heightBox,
                boldText(text: "Sex", color: fontGrey, size: 18),
                Obx(() => Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: controller.genderList.map((gender) {
                        return ChoiceChip(
                          label: Text(gender),
                          selected: controller.selectedGender.value == gender,
                          onSelected: (selected) {
                            if (selected) {
                              controller.selectedGender.value = gender;
                            }
                          },
                        );
                      }).toList(),
                    )),
                30.heightBox,
                boldText(text: "Size", color: fontGrey, size: 18),
                Obx(() => Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: controller.sizesList.map((size) {
                        return ChoiceChip(
                          label: Text(size),
                          selected: controller.selectedSize.value == size,
                          onSelected: (selected) {
                            if (selected) {
                              controller.selectedSize.value = size;
                            }
                          },
                        );
                      }).toList(),
                    )),
                30.heightBox,
                boldText(text: "Skin Color", color: fontGrey, size: 18),
                10.heightBox,
                Obx(() => Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: controller.skinColorList.map((skinColor) {
                        return GestureDetector(
                          onTap: () => controller.selectedSkinColor.value =
                              skinColor['name'],
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: skinColor['color'],
                              border: Border.all(
                                color: controller.selectedSkinColor.value ==
                                        skinColor['name']
                                    ? Colors
                                        .blue // Highlight color when selected
                                    : Colors.transparent,
                              ),
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                          ),
                        );
                      }).toList(),
                    )),
                30.heightBox,
                boldText(text: "Other Color", color: fontGrey, size: 18),
                10.heightBox,
                Obx(() => Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children:
                          controller.clothingColorList.map((clothingColor) {
                        return GestureDetector(
                          onTap: () => controller.selectedClothingColor.value =
                              clothingColor['name'],
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: clothingColor['color'],
                              border: Border.all(
                                color: controller.selectedClothingColor.value ==
                                        clothingColor['name']
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }).toList(),
                    )),
                30.heightBox,
                boldText(text: "Similor ", color: fontGrey, size: 18),
                10.heightBox,
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        1,
                        (index) => controller.pImagesList[index] != null
                            ? Image.file(
                                controller.pImagesList[index],
                                width: 100,
                              ).onTap(() {
                                controller.pickImage(index, context);
                              })
                            : InkWell(
                                onTap: () {
                                  controller.pickImage(index, context);
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                      ),
                    )),

                10.heightBox,
                // normalText(
                //     text: "First image will be your sidplay image",
                //     color: fontGrey),
                25.heightBox,
                // boldText(
                //     text: "Choose product colors", color: fontGrey, size: 18),
                // 10.heightBox,
                // Obx(() => Wrap(
                //       spacing: 8.0,
                //       runSpacing: 8.0,
                //       children: List.generate(
                //           controller.clothingColorList.length, (index) {
                //         var clothingColor = controller.clothingColorList[index];
                //         return GestureDetector(
                //           onTap: () =>
                //               controller.selectedColorIndex.value = index,
                //           child: Container(
                //             width: 40,
                //             height: 40,
                //             decoration: BoxDecoration(
                //               color: clothingColor['color'],
                //               shape: BoxShape.circle, // ปรับเป็นรูปวงกลม
                //               border: Border.all(
                //                 color:
                //                     controller.selectedColorIndex.value == index
                //                         ? Colors.blue
                //                         : Colors.transparent,
                //                 width: 2,
                //               ),
                //             ),
                //           ),
                //         );
                //       }),
                //     )),
                30.heightBox,

                boldText(text: "Mix and Match", color: fontGrey, size: 18),

                Obx(() => Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: controller.mixAndMatchOptions.map((option) {
                        return ChoiceChip(
                          label: Text(option),
                          selected:
                              controller.selectedMixAndMatch.value == option,
                          onSelected: (bool selected) {
                            if (selected) {
                              controller.selectedMixAndMatch.value = option;
                            }
                          },
                        );
                      }).toList(),
                    )),
                10.heightBox,

                30.heightBox,
                productDropdown("Subcollection", controller.subcollectionList,
                    controller.subcollectionvalue, controller),
                30.heightBox,
                customTextField(
                    hint: "eg. 20",
                    label: "Quantity",
                    controller: controller.pquantityController),
                30.heightBox,
                customTextField(
                    hint: "eg. 10,000.00",
                    label: "Price",
                    controller: controller.ppriceController),
                30.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

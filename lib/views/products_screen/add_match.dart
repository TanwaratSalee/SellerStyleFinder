import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/views/products_screen/component/product_dropdown.dart';
import 'package:seller_finalproject/views/products_screen/match_detail.dart';
import 'package:seller_finalproject/views/products_screen/selectProduct.dart';
import 'package:seller_finalproject/views/products_screen/select_item.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';

import '../../controllers/products_controller.dart';

class AddMatchProduct extends StatelessWidget {
  const AddMatchProduct({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();
    
    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: Text("Match Product").text.size(24).fontFamily(medium).make(),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: primaryApp)
                : TextButton(
                    onPressed: () async {},
                    child: Text(save)
                        .text
                        .fontFamily(medium)
                        .color(greyColor)
                        .size(18)
                        .make())
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImagePlaceholder(title: 'Top'),
                SizedBox(width: 16), 
                  Icon(Icons.add).box.roundedFull.make(),
                  // mini: true,backgroundColor: primaryApp,
                SizedBox(width: 16), 
                ImagePlaceholder(title: 'Lower'),
              ],
            ),
            15.heightBox,
                productDropdown("Collection", controller.collectionsList,
                    controller.collectionsvalue, controller),
                15.heightBox,
                customTextField(
                    hint: "Explain clothing matching",
                    label: "Explain clothing matching",
                    isDesc: true,
                    controller: controller.psizeController),
                20.heightBox,
                Text("Suitable for gender")
                    .text
                    .size(16)
                    .color(greyDark1)
                    .fontFamily(medium)
                    .make(),
                10.heightBox,
                Obx(() => Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: controller.genderList.map((gender) {
                        return ChoiceChip(
                          label: Text(
                            gender,
                            style: TextStyle(
                              color: controller.selectedGender.value == gender
                                  ? whiteColor
                                  : greyDark1,
                            ),
                          ).text.size(18).fontFamily(regular).make(),
                          selected: controller.selectedGender.value == gender,
                          onSelected: (selected) {
                            if (selected) {
                              controller.selectedGender.value = gender;
                            }
                          },
                          selectedColor: primaryApp,
                          backgroundColor: thinGrey0,
                        );
                      }).toList(),
                    )),
                10.heightBox,
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
                      controller.allColors.length,
                      (index) => Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: greyColor),
                              color:
                                  controller.allColors[index]['color'] as Color,
                            ),
                            child: InkWell(
                              onTap: () {
                                final selected = controller.selectedColorIndexes
                                    .contains(index);
                                if (selected) {

                                } else {

                                }
                              },
                            ),
                          )
                              .box
                              .margin(EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2))
                              .make(),
                          if (controller.selectedColorIndexes.contains(index))
                            Icon(
                              Icons.done,
                              color: controller.allColors[index]['color'] ==
                                      Colors.white
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

class ImagePlaceholder extends StatelessWidget {
  final String title;
  final String vendorId = FirebaseAuth.instance.currentUser!.uid;

  ImagePlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();
    var product = title.toLowerCase() == 'top' ? controller.selectedTopProduct.value : controller.selectedLowerProduct.value;

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            controller.isloading.value = true;
            try {
              var currentUserUid = vendorId;

              // Fetch products that match the criteria
              var querySnapshot = await FirebaseFirestore.instance
                  .collection('products')
                  .where('vendor_id', isEqualTo: currentUserUid)
                  .where('p_part', isEqualTo: title.toLowerCase())
                  .get();

              controller.isloading.value = false;
              
              Get.to(() => SelectItemPage(
                  products: querySnapshot.docs.map((doc) => Product.fromFirestore(doc.data())).toList(),
                  onProductSelected: (selectedProduct) {
                    // You need to add state management here to update the images
                    controller.setSelectedProduct(selectedProduct, title.toLowerCase()); // This method needs to be implemented in your ProductsController
                  }
                ));
            } catch (e) {
              controller.isloading.value = false;
              print('Error fetching products: $e');
            }
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.camera_alt,
              color: Colors.grey,
            ),
          ),
        ),
        Text(title),
      ],
    );
  }
}



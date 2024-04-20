import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/views/products_screen/select_item.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';

import '../../controllers/products_controller.dart';

class AddMatchProduct extends StatefulWidget {
  const AddMatchProduct({Key? key}) : super(key: key);

  @override
  _AddMatchProductState createState() => _AddMatchProductState();
}

class _AddMatchProductState extends State<AddMatchProduct> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

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
                20.heightBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            bool isSelected =
                                controller.selectedGender.value == gender;
                            return ChoiceChip(
                              showCheckmark: false,
                              label: Text(
                                capitalize(gender),
                                style: TextStyle(
                                  color: isSelected ? primaryApp : greyDark1,
                                ),
                              ).text.size(18).fontFamily(regular).make(),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  controller.selectedGender.value = gender;
                                }
                              },
                              selectedColor: thinPrimaryApp,
                              backgroundColor: thinGrey0,
                              side: isSelected
                                  ? BorderSide(color: primaryApp, width: 2)
                                  : BorderSide(color: greyColor),
                            );
                          }).toList(),
                        )),
                    15.heightBox,
                    Text("Collection")
                        .text
                        .size(16)
                        .color(greyDark1)
                        .fontFamily(medium)
                        .make(),
                    10.heightBox,
                    Obx(() => Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: controller.collectionList.map((collection) {
                            bool isSelected =
                                controller.isCollectionSelected(collection);
                            return ChoiceChip(
                              showCheckmark: false,
                              label: Text(
                                capitalize(collection),
                                style: TextStyle(
                                  color: isSelected ? primaryApp : greyDark1,
                                ),
                              ), // Removed .text.size(18).fontFamily(regular).make() for standard styling
                              selected: isSelected,
                              onSelected: (selected) {
                                controller.toggleCollection(collection);
                              },
                              selectedColor: thinPrimaryApp,
                              backgroundColor: thinGrey0,
                              side: isSelected
                                  ? BorderSide(color: primaryApp, width: 2)
                                  : BorderSide(color: greyColor),
                            );
                          }).toList(),
                        )),
                  ],
                ),
                15.heightBox,
                customTextField(
                    hint: "Explain clothing matching",
                    label: "Explain clothing matching",
                    isDesc: true,
                    controller: controller.psizeController),
                20.heightBox,
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
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: List.generate(
                      controller.allColors.length,
                      (index) => GestureDetector(
                        onTap: () {
                          if (controller.selectedColorIndexes.contains(index)) {
                            controller.selectedColorIndexes.remove(index);
                          } else {
                            controller.selectedColorIndexes.add(index);
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: controller.allColors[index]['color'],
                            border: Border.all(
                              color: controller.selectedColorIndexes
                                      .contains(index)
                                  ? Colors.blueAccent // เปลี่ยนสีเมื่อถูกเลือก
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child:
                                controller.selectedColorIndexes.contains(index)
                                    ? Icon(
                                        Icons.done,
                                        color: controller.allColors[index]
                                                    ['color'] ==
                                                Colors.white
                                            ? Colors.black
                                            : Colors.white,
                                      )
                                    : SizedBox(),
                          ),
                        ),
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

class ImagePlaceholder extends StatefulWidget {
  final String title;
  final String vendorId = FirebaseAuth.instance.currentUser!.uid;

  ImagePlaceholder({Key? key, required this.title}) : super(key: key);

  @override
  _ImagePlaceholderState createState() => _ImagePlaceholderState();
}

class _ImagePlaceholderState extends State<ImagePlaceholder> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            setState(() {
              controller.isloading.value = true;
            });
            try {
              var querySnapshot = await FirebaseFirestore.instance
                  .collection('products')
                  .where('vendor_id', isEqualTo: widget.vendorId)
                  .where('p_part', isEqualTo: widget.title.toLowerCase())
                  .get();

              var products = querySnapshot.docs
                  .map((doc) => Product.fromFirestore(doc.data()))
                  .toList();

              controller.isloading.value = false;

              var selectedProductImages = await Get.to(() => SelectItemPage(
                  products: products,
                  onProductSelected: (selectedProduct) {
                    controller.setSelectedProduct(
                        selectedProduct, widget.title.toLowerCase());
                  }));

              if (selectedProductImages != null) {
                controller.updateProductImages(
                    selectedProductImages, widget.title.toLowerCase());
              }
            } catch (e) {
              controller.isloading.value = false;
              print('Error fetching products: $e');
              Get.snackbar('Error', 'Failed to fetch products',
                  snackPosition: SnackPosition.BOTTOM);
            } finally {
              setState(() {
                controller.isloading.value = false;
              });
            }
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                controller.getProductImages(widget.title.toLowerCase()).isEmpty
                    ? Icon(Icons.camera_alt, color: Colors.grey)
                    : Image.network(
                        controller
                            .getProductImages(widget.title.toLowerCase())
                            .first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, color: Colors.grey),
                      ),
          ),
        ),
        Text(widget.title),
      ],
    );
  }
}

import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/views/products_screen/component/product_dropdown.dart';
import 'package:seller_finalproject/views/products_screen/selectProduct.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';

import '../../controllers/products_controller.dart';

class AddMatchProduct extends StatefulWidget {
  const AddMatchProduct({Key? key}) : super(key: key);

  @override
  State<AddMatchProduct> createState() => _AddMatchProductState();
}

class _AddMatchProductState extends State<AddMatchProduct> {
  String selectedGender = 'All'; // Starting value
  List<String> genderList = ['All', 'Man', 'Woman'];
  // Replace with actual product controller
  // var controller = Get.find<ProductsController>();

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
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectProductPage()),
                        );
                      },
                      child: Icon(Icons.camera_alt_outlined),
                    )
                  ],
                ),
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

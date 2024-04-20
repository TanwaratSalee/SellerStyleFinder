// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';

Widget productDropdown(String hint, List<String> list, RxString dropvalue, ProductsController controller) {
  return Obx(
    () => DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        hint: Text(hint).text.color(greyColor).size(14).make(),
        value: dropvalue.value.isEmpty ? null : dropvalue.value,
        isExpanded: true,
        items: list.map((String e) {
          return DropdownMenuItem<String>(
            value: e,
            child: Text(e).text.make(),
          );
        }).toList(),
        onChanged: (String? newValue) {
          print("New value for collection: $newValue");
          if (newValue != null) {
            dropvalue.value = newValue; // Set new value for current dropdown
            if (hint == "Collection") {
              controller.subcollectionvalue.value = ''; // Reset subcollection when collection changes
              controller.populateSubcollection(newValue);
            }
          }
        },
      ),
    ).box.color(greyColor).padding(const EdgeInsets.symmetric(horizontal: 8, vertical: 6)).border(color: greyColor).roundedSM.make(),
  );
}

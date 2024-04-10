import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';
import 'package:seller_finalproject/views/widgets/text_style.dart';

Widget productDropdown(hint, List<String> list, dropvalue, ProductsController controller) {
  return Obx(
    () =>  DropdownButtonHideUnderline(
      child: DropdownButton(
        hint: normalText(text: "$hint", color: fontGrey),
        value: dropvalue.value == '' ? null : dropvalue.value,
        isExpanded: true,
        items: list.map((e) {
          return DropdownMenuItem( 
            value: e,
            child: e.toString().text.make(), 
          );
        }).toList(),
        onChanged: (newValue) {
          if(hint == "Collection") {
            controller.subcollectionvalue.value = '';
            controller.populateSubcollection(newValue.toString());
          }
          dropvalue.value = newValue.toString();
        },
      ),
    ).box.white.padding(const EdgeInsets.symmetric(horizontal: 4)).roundedSM.make(),
  );
}
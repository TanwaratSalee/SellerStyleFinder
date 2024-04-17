import 'package:flutter/services.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';

Widget customTextField({label, hint, controller,isDesc = false}) {
  return TextFormField(
    style: const TextStyle(color: greyDark2),
    controller: controller,
    maxLines: isDesc? 4 : 1,
    decoration: InputDecoration(
      isDense: true,
        label: Text(label).text.size(16).color(greyDark1).fontFamily(regular).make(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: thinGrey01),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: thinGrey01),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: greyColor,
            )),
        hintText: hint,
        hintStyle: const TextStyle(color: greyColor)),
  ).box.color(thinGrey0).roundedSM/* .outerShadowMd */.make();
}

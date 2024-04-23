import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:seller_finalproject/const/const.dart';

Widget customTextField({
  required TextEditingController controller,
  required String label,
  String hint = '',
  bool isDesc = false,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      isDense: true,
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: thinGrey01),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: thinGrey01),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: greyColor),
      ),
    ),
    style: const TextStyle(color: greyDark2),
    maxLines: isDesc ? 4 : 1,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
  ).box.color(thinGrey0).roundedSM.make();
}

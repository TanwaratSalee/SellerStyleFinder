import 'package:flutter/services.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';

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
        borderSide: const BorderSide(color: greyColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: greyLine),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: greyColor),
      ),
    ),
    style: const TextStyle(color: blackColor),
    maxLines: isDesc ? 4 : 1,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
  );
}

Widget customTextFieldInput({
  required TextEditingController controller,
  required String heading,
  bool isDesc = false,
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        heading,
        style: const TextStyle(
          color: blackColor,
          fontSize: 16, // Customize the font size for the heading
        ),
      ),
      3.heightBox,
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: redColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: greyLine),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: greyMessage),
          ),
        ),
        style: const TextStyle(
            color: blackColor, fontSize: 14, fontFamily: regular),
        maxLines: isDesc ? 3 : 1,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
      ),
    ],
  );
}

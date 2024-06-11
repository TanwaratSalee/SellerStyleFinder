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
      labelStyle: const TextStyle(
              color: greyDark, fontFamily: regular, fontSize: 14),
          hintStyle: const TextStyle(
              color: greyDark, fontFamily: regular, fontSize: 12),
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
        borderSide: const BorderSide(color: Color.fromRGBO(149, 155, 155, 1)),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
    style: TextStyle(
      color: blackColor,
      fontSize: 14,
      fontFamily: regular,
    ),
    maxLines: isDesc ? 5 : 1,
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

class customTextFieldPassword extends StatefulWidget {
  final String? title;
  final String? label;
  final TextEditingController? controller;
  final bool isPass;
  final bool readOnly;
  final VoidCallback? onTap;

  const customTextFieldPassword({
    Key? key,
    this.title,
    this.label,
    this.controller,
    this.isPass = false,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  _customTextFieldPasswordState createState() =>
      _customTextFieldPasswordState();
}

class _customTextFieldPasswordState extends State<customTextFieldPassword> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          obscureText: widget.isPass ? _obscureText : false,
          controller: widget.controller,
          readOnly: widget.readOnly,
          obscuringCharacter: '●',
          decoration: InputDecoration(
            isDense: true,
            labelText: widget.label,
            labelStyle: const TextStyle(
                color: greyDark, fontFamily: regular, fontSize: 14),
            hintStyle: const TextStyle(
                color: greyDark, fontFamily: regular, fontSize: 12),
            filled: true,
            fillColor: whiteColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: greyLine),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: greyColor),
            ),
            suffixIcon: widget.isPass
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
          style: TextStyle(
            color: blackColor,
            fontSize: _obscureText ? 14 : 14,
            fontFamily: regular,
            letterSpacing: _obscureText ? 2 : 1,
          ),
        ),
      ],
    );
  }
}

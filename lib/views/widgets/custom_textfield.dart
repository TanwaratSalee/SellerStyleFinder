import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/views/widgets/text_style.dart';

Widget customTextField({label, hint, controller,isDesc = false}) {
  return TextFormField(
    style: const TextStyle(color: fontGreyDark),
    controller: controller,
    maxLines: isDesc? 4 : 1,
    decoration: InputDecoration(
      isDense: true,
        label: normalText(text: label, color: fontGreyDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: whiteColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: fontLightGrey),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: fontGrey,
            )),
        hintText: hint,
        hintStyle: const TextStyle(color: fontGrey)),
  ).box.white.rounded.outerShadowMd.make();
}

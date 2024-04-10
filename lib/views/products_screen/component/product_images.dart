import 'package:seller_finalproject/const/const.dart';

Widget productImages({required label, onPass}) {
  return "$label"
      .text
      .bold
      .color(fontGrey)
      .size(16)
      .makeCentered()
      .box
      .color(fontLightGrey)
      .size(100, 100)
      .roundedSM
      .make();
}

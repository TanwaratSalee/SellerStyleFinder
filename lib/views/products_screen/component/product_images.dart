import 'package:seller_finalproject/const/const.dart';

Widget productImages({required label, onPass}) {
  return "$label"
      .text
      .bold
      .color(greyColor)
      .size(16)
      .makeCentered()
      .box
      .color(thinGrey01)
      .size(100, 100)
      .roundedSM
      .make();
}

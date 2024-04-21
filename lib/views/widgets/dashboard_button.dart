import 'package:seller_finalproject/const/const.dart';

Widget dashboardButton(context, {title, count, icon}) {
  var size = MediaQuery.of(context).size;

  return Row(
    children: [
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title).text.size(16).make(),
          // Text(count).text.size(20).make()
        ],
      )),
      Image.asset(
        icon,
        width: 40,
        color: whiteColor,
      )
    ],
  )
      .box
      .color(primaryApp)
      .rounded
      .size(size.width * 0.4, 80)
      .padding(const EdgeInsets.all(12.0))
      .make();
}

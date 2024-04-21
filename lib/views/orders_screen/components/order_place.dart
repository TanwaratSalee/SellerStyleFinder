import 'package:seller_finalproject/const/styles.dart';

import '../../../const/const.dart';

Widget orderPlaceDetails({title1, title2, d1, d2}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
    child:  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$title1").text.size(15).fontFamily(bold).make(),
            Text("$d1").text.size(14).fontFamily(regular).make(),
            ],
        ),
        SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("$title2").text.size(15).fontFamily(bold).make(),
            Text("$d2").text.size(14).fontFamily(regular).make(),
            ],
          ),
        )
      ],
    ),
  );
}
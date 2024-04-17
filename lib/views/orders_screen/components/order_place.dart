import 'package:seller_finalproject/views/widgets/text_style.dart';

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
            boldText(text: "$title1", color: blackColor),
            normalText(text: "$d1", color: primaryApp)
            ],
        ),
        SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            boldText(text: "$title2", color: greyDark2),
            normalText(text: "$d2", color: greyColor)
            ],
          ),
        )
      ],
    ),
  );
}
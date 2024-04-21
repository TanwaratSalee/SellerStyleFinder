import 'package:seller_finalproject/const/const.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
import 'package:seller_finalproject/const/styles.dart';

AppBar appbarWidget(title) {
  return AppBar(
    backgroundColor: whiteColor,
    automaticallyImplyLeading: false,
    title: Text( title).text.size(22).fontFamily(bold).make(),
    actions: [
      Text(intl.DateFormat('EEE,MMM d ' 'yyyy').format(DateTime.now()),
          ).text.color(greyDark2,).make(),
      10.widthBox,
    ],
  );
}

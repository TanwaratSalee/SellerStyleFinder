import 'package:seller_finalproject/const/const.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
import 'package:seller_finalproject/const/styles.dart';

AppBar appbarWidget(title) {
  return AppBar(
    backgroundColor: whiteColor,
    automaticallyImplyLeading: false,
    title: Text( title).text.size(24).fontFamily(semiBold).make(),
    actions: [
      Text(intl.DateFormat('EEE,MMM d ' 'yyyy').format(DateTime.now()),
          ).text.size(14).color(greyDark,).make(),
      10.widthBox,
    ],
  );
}

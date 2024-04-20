import 'package:seller_finalproject/const/const.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
import 'package:seller_finalproject/const/styles.dart';
import 'text_style.dart';

AppBar appbarWidget(title) {
  return AppBar(
    backgroundColor: whiteColor,
    automaticallyImplyLeading: false,
    title: Text( title).text.size(22).fontFamily(bold).make(),
    actions: [
      boldText(
          text: intl.DateFormat('EEE,MMM d ' 'yyyy').format(DateTime.now()),
          color: greyDark2,),
      10.widthBox,
    ],
  );
}

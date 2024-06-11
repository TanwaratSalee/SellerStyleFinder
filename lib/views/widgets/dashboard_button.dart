import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';

Widget dashboardButton(context, {title, count, icon}) {
  var size = MediaQuery.of(context).size;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Image.asset(
        icon,
        width: 20,
        color: primaryApp,
      ),
      10.widthBox,
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title).text.fontFamily(semiBold).color(primaryApp).size(16).make(),
            Text(count.toString()).text.color(primaryApp).fontFamily(semiBold).size(20).make()  
          ],
        ),
      ),
      
    ],
  )
  .box
  .color(thinPrimaryApp)
  .rounded
  .border(color: primaryApp)
  // .size(size.width * 0.4, 80)
  .padding(const EdgeInsets.fromLTRB(16,12,16,7))
  .margin(const EdgeInsets.only(bottom: 5))
  .make();
}



// Widget dashboardButton(context, {title, count, icon}) {
//   var size = MediaQuery.of(context).size;

//   return Row(
//     children: [
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(title).text.color(whiteColor).size(16).make(),
//             Text(count.toString()).text.color(whiteColor).size(20).make()  // แสดงค่า count ที่รับเข้ามา
//           ],
//         ),
//       ),
//       Image.asset(
//         icon,
//         width: 40,
//         color: whiteColor,
//       )
//     ],
//   )
//   .box
//   .color(primaryApp)
//   .rounded
//   .size(size.width * 0.4, 80)
//   .padding(const EdgeInsets.all(12.0))
//   .make();
// }


import 'package:seller_finalproject/const/const.dart';

Widget dashboardButton(context, {title, count, icon}) {
  var size = MediaQuery.of(context).size;

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Image.asset(
        icon,
        width: 22,
        color: whiteColor,
      ),
      10.widthBox,
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title).text.color(whiteColor).size(16).make(),
            Text(count.toString()).text.color(whiteColor).size(20).make()  // แสดงค่า count ที่รับเข้ามา
          ],
        ),
      ),
      
    ],
  )
  .box
  .color(primaryApp)
  .rounded
  // .size(size.width * 0.4, 80)
  .padding(const EdgeInsets.all(14.0))
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


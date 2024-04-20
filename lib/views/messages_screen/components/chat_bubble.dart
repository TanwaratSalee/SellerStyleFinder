import 'package:seller_finalproject/const/const.dart';

Widget chatBubble() {
  return Directionality(
    //textDirection: datal ['uid'] == currentUser!.uid ? TextDirection.rtl : TextDirection.ltr
    textDirection: TextDirection.rtl, 
    child: Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        // color: data['uid'] == currentUser!.uid ? red : blackColor,
        color: primaryApp,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20)
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "${data['msg]}".text.white.size(16).make(),
            Text( "Your message here..."),
            10.heightBox,
            // time.text.color(whiteColor.withOpacity(0.5)).make(),
            Text( "10.45PM")
          ],
        ),
    ));
}
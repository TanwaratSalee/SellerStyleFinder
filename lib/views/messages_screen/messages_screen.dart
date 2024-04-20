import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/messages_screen/chat_screen.dart';
import 'package:seller_finalproject/views/widgets/text_style.dart';
import 'package:get/get.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: boldText(text: messages, size: 16.0, color: blackColor),
        ),
        body: StreamBuilder(
            stream: StoreServices.getMessages(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return loadingIndicator();
              } else {
                var data = snapshot.data!.docs;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: List.generate(data.length,
                          (index) {
                            var t = data[index]['created_on'] == null ? DateTime.now() : data[index]['created_on'].toDate();
                            var time = intl.DateFormat("h:mma").format(t);

                            return ListTile(
                                onTap: () {
                                  Get.to(() => const ChatScreen());
                                },
                                leading: const CircleAvatar(
                                    backgroundColor: primaryApp,
                                    child: Icon(
                                      Icons.person,
                                      color: whiteColor,
                                    )),
                                title: boldText(
                                    text: "${data[index]['sender_name']}", color: blackColor),
                                subtitle: normalText(
                                    text: "${data[index]['last_msg']}", color: greyColor),
                                trailing: normalText(
                                    text: time, color: greyColor),
                              );
                          }),
                    ),
                  ),
                );
              }
            }));
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:seller_finalproject/const/const.dart';
// import 'package:seller_finalproject/controllers/loading_Indcator.dart';
// import 'package:seller_finalproject/services/store_services.dart';
// import 'package:seller_finalproject/views/messages_screen/chat_screen.dart';
// import 'package:seller_finalproject/views/widgets/text_style.dart';
// import 'package:get/get.dart';
// // ignore: unused_import, depend_on_referenced_packages
// import 'package:intl/intl.dart' as intl;

// class MessagesScreen extends StatelessWidget {
//   const MessagesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: boldText(text: messages, size: 16.0, color: blackColor),
//         ),
//         body: StreamBuilder(
//             stream: StoreServices.getMessages(currentUser!.uid),
//             builder:
//                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (!snapshot.hasData) {
//                 return loadingIndicator();
//               } else {
//                 var data = snapshot.data!.docs;
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     child: Column(
//                       children: List.generate(data.length, (index) {
//                         var t = data[index]['created_on'] == null
//                             ? DateTime.now()
//                             : data[index]['created_on'].toDate();
//                         var time = intl.DateFormat("h:mma").format(t);

//                         return ListTile(
//                           onTap: () {
//                             Get.to(() => const ChatScreen());
//                           },
//                           leading: const CircleAvatar(
//                               backgroundColor: primaryApp,
//                               child: Icon(
//                                 Icons.person,
//                                 color: whiteColor,
//                               )),
//                           title: boldText(
//                               text: "${data[index]['sender_name']}",
//                               color: blackColor),
//                           subtitle: normalText(
//                               text: "${data[index]['last_msg']}",
//                               color: greyColor),
//                           trailing: normalText(text: time, color: greyColor),
//                         );
//                       }),
//                     ),
//                   ),
//                 );
//               }
//             }));
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:seller_finalproject/views/messages_screen/chat_screen.dart';

// class MessagesScreen extends StatelessWidget {
//   const MessagesScreen({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Messages'),
//       ),
//       body: ListView(
//         children: <Widget>[
//           Card(
//             child: ListTile(
//               title: Text('Nattylovelyso'), // เปลี่ยน title เป็นชื่อของผู้ใช้
//               subtitle: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text('This is the first message'),
//                   Text(
//                     '10:00 AM', // แสดงเวลาของข้อความ
//                     style: TextStyle(
//                       color: greyColor,
//                     ),
//                   ),
//                 ],
//               ),
//               leading: CircleAvatar(
//                 // เปลี่ยนไอคอนข้อความเป็นรูปภาพของผู้ส่งแชท
//                 child: Icon(Icons.person),
//               ),
//               onTap: () {
//                 Get.to(() => const ChatScreen());
//               },
//             ),
//           ),
//           Card(
//             child: ListTile(
//               title: Text('Kate theKitty'), // เปลี่ยน title เป็นชื่อของผู้ใช้
//               subtitle: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text('This is the second message'),
//                   Text(
//                     '11:30 AM', // แสดงเวลาของข้อความ
//                     style: TextStyle(
//                       color: greyColor,
//                     ),
//                   ),
//                 ],
//               ),
//               leading: CircleAvatar(
//                 // เปลี่ยนไอคอนข้อความเป็นรูปภาพของผู้ส่งแชท
//                 child: Icon(Icons.person),
//               ),
//               onTap: () {
//                 Get.to(() => const ChatScreen()); // Add your onTap logic here
//               },
//             ),
//           ),
//           Card(
//             child: ListTile(
//               title: Text('Noey Miyabi '), // เปลี่ยน title เป็นชื่อของผู้ใช้
//               subtitle: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text('This is the second message'),
//                   Text(
//                     '11:30 AM', // แสดงเวลาของข้อความ
//                     style: TextStyle(
//                       color: greyColor,
//                     ),
//                   ),
//                 ],
//               ),
//               leading: CircleAvatar(
//                 // เปลี่ยนไอคอนข้อความเป็นรูปภาพของผู้ส่งแชท
//                 child: Icon(Icons.person),
//               ),
//               onTap: () {
//                 Get.to(() => const ChatScreen()); // Add your onTap logic here
//               },
//             ),
//           ),
//           Card(
//             child: ListTile(
//               title: Text('tung tung tung'), // เปลี่ยน title เป็นชื่อของผู้ใช้
//               subtitle: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text('This is the second message'),
//                   Text(
//                     '11:30 AM', // แสดงเวลาของข้อความ
//                     style: TextStyle(
//                       color: greyColor,
//                     ),
//                   ),
//                 ],
//               ),
//               leading: CircleAvatar(
//                 // เปลี่ยนไอคอนข้อความเป็นรูปภาพของผู้ส่งแชท
//                 child: Icon(Icons.person),
//               ),
//               onTap: () {
//                 Get.to(() => const ChatScreen()); // Add your onTap logic here
//               },
//             ),
//           ),
//           Card(
//             child: ListTile(
//               title: Text(' Aj.'), // เปลี่ยน title เป็นชื่อของผู้ใช้
//               subtitle: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Text('This is the second message'),
//                   Text(
//                     '11:30 AM', // แสดงเวลาของข้อความ
//                     style: TextStyle(
//                       color: greyColor,
//                     ),
//                   ),
//                 ],
//               ),
//               leading: CircleAvatar(
//                 // เปลี่ยนไอคอนข้อความเป็นรูปภาพของผู้ส่งแชท
//                 child: Icon(Icons.person),
//               ),
//               onTap: () {
//                 Get.to(() => const ChatScreen()); // Add your onTap logic here
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

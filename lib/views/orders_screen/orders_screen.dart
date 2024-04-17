import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/orders_controller.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/orders_screen/order_details.dart';
import 'package:seller_finalproject/views/widgets/appbar_widget.dart';
import 'package:seller_finalproject/views/widgets/text_style.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;


class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var controllers = Get.put(OrdersController()); 

    return Scaffold(
      appBar: appbarWidget(orders),
      body: StreamBuilder(
        stream: StoreServices.getOrders(currentUser!.uid), 
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
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
                        var time = data[index]['order_date'].toDate();

                        return ListTile(
                            onTap: () {
                              Get.to(() => OrderDetails(data: data[index]));
                            },
                            tileColor: thinGrey01,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)
                            ),
                            title: boldText(text:"${data[index]['order_code']}", color: greyDark2),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month, color: greyDark2),
                                    10.widthBox,
                                    boldText(text: intl.DateFormat().add_yMd().format(time),color: greyColor),
                                  ],
                                ),
                                3.heightBox,
                                Row(
                                  children: [
                                    const Icon(Icons.payment, color: greyDark2),
                                    10.widthBox,
                                    boldText(text: unpaid,color: redColor),
                                  ],
                                )
                              ],
                            ),
                            // ignore: unnecessary_string_escapes
                            trailing: boldText(text: "${data[index]['total_amount']} Bath", color: blackColor, size: 16.0),
                          ).box.margin(const EdgeInsets.only(bottom: 5)).make();
                      }
                        ),
                ),
              ),
            );
          }
        })
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:seller_finalproject/const/const.dart';
// import 'package:seller_finalproject/controllers/loading_Indcator.dart';
// import 'package:seller_finalproject/controllers/orders_controller.dart';
// import 'package:seller_finalproject/services/store_services.dart';
// import 'package:seller_finalproject/views/orders_screen/order_details.dart';
// import 'package:seller_finalproject/views/widgets/appbar_widget.dart';
// import 'package:seller_finalproject/views/widgets/text_style.dart';
// import 'package:get/get.dart';
// // ignore: depend_on_referenced_packages
// import 'package:intl/intl.dart' as intl;

// class OrdersScreen extends StatelessWidget {
//   const OrdersScreen({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     var controllers = Get.put(OrdersController());

//     return DefaultTabController(
//       length: 6,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Orders'),
//           bottom: const TabBar(
//             isScrollable: true,
//             tabs: [
//               Tab(
//                 child: Row(
//                   children: [
//                     const Text('All '),
//                     Text('(10)'),
//                   ],
//                 ),
//               ),
//               Tab(
//                 child: Row(
//                   children: [
//                     const Text('Unpaid '),
//                     Text('(5)'),
//                   ],
//                 ),
//               ),
//               Tab(
//                 child: Row(
//                   children: [
//                     const Text('In Transit '),
//                     Text('(7)'),
//                   ],
//                 ),
//               ),
//               Tab(
//                 child: Row(
//                   children: [
//                     const Text('Awaiting Shipment '),
//                     Text('(3)'),
//                   ],
//                 ),
//               ),
//               Tab(
//                 child: Row(
//                   children: [
//                     const Text('Delivered '),
//                     Text('(15)'),
//                   ],
//                 ),
//               ),
//               Tab(
//                 child: Row(
//                   children: [
//                     const Text('Completed '),
//                     Text('(20)'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // สินค้าของแท็บ All
//             StreamBuilder(
//                 stream: StoreServices.getOrders(currentUser!.uid),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (!snapshot.hasData) {
//                     return loadingIndicator();
//                   } else {
//                     var data = snapshot.data!.docs;

//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: ListView.builder(
//                         physics: const BouncingScrollPhysics(),
//                         itemCount: data.length,
//                         itemBuilder: (context, index) {
//                           // var time = data[index]['order_date'].toDate();
//                           // var productImage = data[index]
//                           //     ['assets/product.jpg']; // URL ของรูปภาพสินค้า
//                           // var productName =
//                           //     data[index]['product_name']; // ชื่อสินค้า
//                           // var productPrice =
//                           //     data[index]['product_price']; // ราคาสินค้า
//                           // var productQuantity =
//                           //     data[index]['product_quantity']; // จำนวนสินค้า
//                           // var totalPrice =
//                           //     data[index]['total_amount']; // ราคารวมทั้งหมด

//                           return Container(
//                             padding: const EdgeInsets.all(8.0),
//                             margin: const EdgeInsets.only(bottom: 8.0),
//                             decoration: BoxDecoration(
//                               color: thinGrey01,
//                               borderRadius: BorderRadius.circular(12.0),
//                             ),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // ส่วนแสดงรูปภาพสินค้า
//                                 Container(
//                                   width: 100,
//                                   height: 100,
//                                   // decoration: BoxDecoration(
//                                   //   color: productImage != null
//                                   //       ? Colors.transparent
//                                   //       : Colors.grey, // สีเทาเมื่อไม่มีรูปภาพ
//                                   //   borderRadius: BorderRadius.circular(12.0),
//                                   // ),
//                                   //   child: productImage != null
//                                   //       ? Image.network(
//                                   //           productImage,
//                                   //           fit: BoxFit.cover,
//                                   //         )
//                                   //       : Icon(Icons.image,
//                                   //           color: Colors.white,
//                                   //           size:
//                                   //               50), // ไอคอนรูปภาพเมื่อไม่มีรูปภาพ
//                                 ),
//                                 const SizedBox(width: 10),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       // ส่วนแสดงรหัสออร์เดอร์
//                                       Text(
//                                         "${data[index]['order_code']}",
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: greyDark2,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 5),
//                                       // ส่วนแสดงวันที่
//                                       Row(
//                                         children: [
//                                           Icon(Icons.calendar_month,
//                                               color: greyDark2),
//                                           const SizedBox(width: 5),
//                                           // Text(
//                                           //   intl.DateFormat()
//                                           //       .add_yMd()
//                                           //       .format(time),
//                                           //   style: TextStyle(color: greyColor),
//                                           // ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 5),
//                                       // ส่วนแสดงสถานะการชำระเงิน
//                                       Row(
//                                         children: [
//                                           Icon(Icons.payment,
//                                               color: greyDark2),
//                                           const SizedBox(width: 5),
//                                           Text(unpaid,
//                                               style: TextStyle(color: red)),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 // ส่วนแสดงราคารวม
//                                 // Text(
//                                 //   "$totalPrice Bath",
//                                 //   style: TextStyle(
//                                 //     fontWeight: FontWeight.bold,
//                                 //     color: blackColor,
//                                 //     fontSize: 16.0,
//                                 //   ),
//                                 // ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   }
//                 }),
//             // สินค้าของแท็บ Unpaid
//             // TODO: เพิ่มโค้ดสำหรับแสดงสินค้าของแท็บ Unpaid ตรงนี้
//             Container(),
//             // สินค้าของแท็บ In Transit
//             // TODO: เพิ่มโค้ดสำหรับแสดงสินค้าของแท็บ In Transit ตรงนี้
//             Container(),
//             // สินค้าของแท็บ Awaiting Shipment
//             // TODO: เพิ่มโค้ดสำหรับแสดงสินค้าของแท็บ Awaiting Shipment ตรงนี้
//             Container(),
//             // สินค้าของแท็บ Delivered
//             // TODO: เพิ่มโค้ดสำหรับแสดงสินค้าของแท็บ Delivered ตรงนี้
//             Container(),
//             // สินค้าของแท็บ Completed
//             // TODO: เพิ่มโค้ดสำหรับแสดงสินค้าของแท็บ Completed ตรงนี้
//             Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }

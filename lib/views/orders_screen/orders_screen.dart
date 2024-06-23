// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart' as intl;
// import 'package:intl/intl.dart';
// import 'package:seller_finalproject/const/const.dart';
// import 'package:seller_finalproject/const/styles.dart';
// import 'package:seller_finalproject/controllers/orders_controller.dart';
// import 'package:seller_finalproject/services/store_services.dart';
// import 'package:seller_finalproject/views/orders_screen/order_details.dart';
// import 'package:seller_finalproject/views/widgets/appbar_widget.dart';

// class OrdersScreen extends StatefulWidget {
//   const OrdersScreen({Key? key}) : super(key: key);

//   @override
//   State<OrdersScreen> createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final OrdersController controller = Get.put(OrdersController());

//   Future<int> _getOrderCount(String filter) async {
//     var snapshot = await StoreServices.getOrders(currentUser!.uid).first;
//     var data = snapshot.docs.where((order) {
//       switch (filter) {
//         case 'New':
//           return order['order_placed'] == true &&
//               order['order_confirmed'] == false &&
//               order['order_delivered'] == false &&
//               order['order_on_delivery'] == false;
//         case 'Order':
//           return order['order_placed'] == true &&
//               order['order_confirmed'] == true &&
//               order['order_delivered'] == false &&
//               order['order_on_delivery'] == false;
//         case 'Delivery':
//           return order['order_placed'] == true &&
//               order['order_confirmed'] == true &&
//               order['order_delivered'] == false &&
//               order['order_on_delivery'] == true;
//         case 'History':
//           return order['order_placed'] == true &&
//               order['order_confirmed'] == true &&
//               order['order_delivered'] == true &&
//               order['order_on_delivery'] == true;
//         default:
//           return false;
//       }
//     }).toList();
//     return data.length;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Orders'),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(48.0),
//           child: FutureBuilder<Map<String, int>>(
//             future: Future.wait([
//               _getOrderCount('New'),
//               _getOrderCount('Order'),
//               _getOrderCount('Delivery'),
//               _getOrderCount('History'),
//             ]).then((counts) => {
//                   'New': counts[0],
//                   'Order': counts[1],
//                   'Delivery': counts[2],
//                   'History': counts[3],
//                 }),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               var counts = snapshot.data!;
//               return TabBar(
//                 controller: _tabController,
//                 labelColor: primaryApp,
//                 indicatorColor: primaryApp,
//                 indicatorWeight: 2.0,
//                 tabs: [
//                   Tab(text: 'New (${counts['New']})'),
//                   Tab(text: 'Order (${counts['Order']})'),
//                   Tab(text: 'Delivery (${counts['Delivery']})'),
//                   Tab(text: 'History (${counts['History']})'),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           buildOrderList('New'),
//           buildOrderList('Order'),
//           buildOrderList('Delivery'),
//           buildOrderList('History'),
//         ],
//       ),
//     );
//   }

//   Widget buildOrderList(String filter) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: StoreServices.getOrders(currentUser!.uid),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(
//             child: Text(
//               'No order yet!',
//               style: TextStyle(fontSize: 18, color: greyColor),
//             ),
//           );
//         }

//         var data = snapshot.data!.docs.where((order) {
//           switch (filter) {
//             case 'New':
//               return order['order_placed'] == true &&
//                   order['order_confirmed'] == false &&
//                   order['order_delivered'] == false &&
//                   order['order_on_delivery'] == false;
//             case 'Order':
//               return order['order_placed'] == true &&
//                   order['order_confirmed'] == true &&
//                   order['order_delivered'] == false &&
//                   order['order_on_delivery'] == false;
//             case 'Delivery':
//               return order['order_placed'] == true &&
//                   order['order_confirmed'] == true &&
//                   order['order_delivered'] == false &&
//                   order['order_on_delivery'] == true;
//             case 'History':
//               return order['order_placed'] == true &&
//                   order['order_confirmed'] == true &&
//                   order['order_delivered'] == true &&
//                   order['order_on_delivery'] == true;
//             default:
//               return false;
//           }
//         }).toList();

//         return Padding(
//           padding: const EdgeInsets.all(8),
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               children: List.generate(data.length, (index) {
//                 var order = data[index];
//                 var time = order['order_date'].toDate();
//                 return buildOrderItem(order, time);
//               }),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget buildOrderItem(DocumentSnapshot order, DateTime time) {
//     return Container(
//       child: InkWell(
//         onTap: () => Get.to(() => OrderDetails(data: order)),
//         child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Order code : ${order['order_code']}")
//                       .text
//                       .size(16)
//                       .fontFamily(medium)
//                       .make(),
//                   Row(
//                     children: [
//                       const Icon(Icons.calendar_month, color: greyDark),
//                       const SizedBox(width: 10),
//                       Text(intl.DateFormat().add_yMd().format(time)),
//                     ],
//                   ),
//                 ],
//               ),
//               ...buildProductList(order['orders'])
//             ],
//           ).paddingSymmetric(horizontal: 8, vertical: 6),
//         ),
//       )
//           .box
//           .white
//           .margin(const EdgeInsets.symmetric(vertical: 8))
//           .outerShadow
//           .border(color: greyLine)
//           .rounded
//           .make(),
//     );
//   }

//   List<Widget> buildProductList(List orders) {
//     return orders.map<Widget>((order) {
//       return Padding(
//         padding: const EdgeInsets.only(top: 10),
//         child: Row(
//           children: [
//             Text("${order['qty']}x",
//                 style: const TextStyle(fontSize: 14, fontFamily: regular)),
//             const SizedBox(width: 5),
//             Image.network(order['img'],
//                 width: 55, height: 55, fit: BoxFit.cover),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(order['title'],
//                       style: const TextStyle(fontSize: 16, fontFamily: medium),
//                       overflow: TextOverflow.ellipsis),
//                   Text(
//                     "${NumberFormat('#,##0').format(double.parse(order['price'].toString()))} Bath",
//                   ).text.size(14).fontFamily(regular).color(greyColor).make(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }).toList();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/orders_controller.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/orders_screen/order_details.dart';
import 'package:seller_finalproject/views/widgets/appbar_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrdersController controller = Get.put(OrdersController());

  Future<Map<String, dynamic>> getProductDetails(String productId) async {
    if (productId.isEmpty) {
      debugPrint('Error: productId is empty.');
      return {
        'name': 'Unknown Product',
        'id': productId,
        'imageUrl': '',
        'price': 0.0
      };
    }

    try {
      var productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();
      if (productSnapshot.exists) {
        debugPrint('Document ID: ${productSnapshot.id}');
        var productData = productSnapshot.data() as Map<String, dynamic>?;
        return {
          'name': productData?['name'] ?? 'Unknown Product',
          'id': productId,
          'imageUrl':
              (productData?['imgs'] != null && productData!['imgs'].isNotEmpty)
                  ? productData['imgs'][0]
                  : '',
          'price': productData != null && productData['price'] != null
              ? double.parse(productData['price'].toString())
              : 0.0,
        };
      } else {
        return {
          'name': 'Unknown Product',
          'id': productId,
          'imageUrl': '',
          'price': 0.0
        };
      }
    } catch (e) {
      debugPrint('Error getting product details: $e');
      return {
        'name': 'Unknown Product',
        'id': productId,
        'imageUrl': '',
        'price': 0.0
      };
    }
  }

  Future<int> _getOrderCount(String filter) async {
    var snapshot = await StoreServices.getOrders(currentUser!.uid).first;
    var data = snapshot.docs.where((order) {
      switch (filter) {
        case 'New':
          return order['order_placed'] == true &&
              order['order_confirmed'] == false &&
              order['order_delivered'] == false &&
              order['order_on_delivery'] == false;
        case 'Order':
          return order['order_placed'] == true &&
              order['order_confirmed'] == true &&
              order['order_delivered'] == false &&
              order['order_on_delivery'] == false;
        case 'Delivery':
          return order['order_placed'] == true &&
              order['order_confirmed'] == true &&
              order['order_delivered'] == false &&
              order['order_on_delivery'] == true;
        case 'History':
          return order['order_placed'] == true &&
              order['order_confirmed'] == true &&
              order['order_delivered'] == true &&
              order['order_on_delivery'] == true;
        default:
          return false;
      }
    }).toList();
    return data.length;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Orders'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: StoreServices.getOrders(currentUser!.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var data = snapshot.data!.docs;
                var newCount = data
                    .where((order) =>
                        order['order_placed'] == true &&
                        order['order_confirmed'] == false &&
                        order['order_delivered'] == false &&
                        order['order_on_delivery'] == false)
                    .length;
                var orderCount = data
                    .where((order) =>
                        order['order_placed'] == true &&
                        order['order_confirmed'] == true &&
                        order['order_delivered'] == false &&
                        order['order_on_delivery'] == false)
                    .length;
                var deliveryCount = data
                    .where((order) =>
                        order['order_placed'] == true &&
                        order['order_confirmed'] == true &&
                        order['order_delivered'] == false &&
                        order['order_on_delivery'] == true)
                    .length;
                var historyCount = data
                    .where((order) =>
                        order['order_placed'] == true &&
                        order['order_confirmed'] == true &&
                        order['order_delivered'] == true &&
                        order['order_on_delivery'] == true)
                    .length;

                return TabBar(
                  controller: _tabController,
                  labelColor: primaryApp,
                  indicatorColor: primaryApp,
                  indicatorWeight: 2.0,
                  tabs: [
                    Tab(text: 'New ($newCount)'),
                    Tab(text: 'Order ($orderCount)'),
                    Tab(text: 'Delivery ($deliveryCount)'),
                    Tab(text: 'History ($historyCount)'),
                  ],
                );
              },
            ),
          )),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildOrderList('New'),
          buildOrderList('Order'),
          buildOrderList('Delivery'),
          buildOrderList('History'),
        ],
      ),
    );
  }

  Widget buildOrderList(String filter) {
    return StreamBuilder<QuerySnapshot>(
      stream: StoreServices.getOrders(currentUser!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No order yet!',
              style: TextStyle(fontSize: 18, color: greyColor),
            ),
          );
        }

        var data = snapshot.data!.docs.where((order) {
          switch (filter) {
            case 'New':
              return order['order_placed'] == true &&
                  order['order_confirmed'] == false &&
                  order['order_delivered'] == false &&
                  order['order_on_delivery'] == false;
            case 'Order':
              return order['order_placed'] == true &&
                  order['order_confirmed'] == true &&
                  order['order_delivered'] == false &&
                  order['order_on_delivery'] == false;
            case 'Delivery':
              return order['order_placed'] == true &&
                  order['order_confirmed'] == true &&
                  order['order_delivered'] == false &&
                  order['order_on_delivery'] == true;
            case 'History':
              return order['order_placed'] == true &&
                  order['order_confirmed'] == true &&
                  order['order_delivered'] == true &&
                  order['order_on_delivery'] == true;
            default:
              return false;
          }
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: List.generate(data.length, (index) {
                var order = data[index];
                var time = order['created_at'].toDate();
                return buildOrderItem(order, time);
              }),
            ),
          ),
        );
      },
    );
  }

  Widget buildOrderItem(DocumentSnapshot order, DateTime time) {
    // ดึงค่าจาก field 'total_amount' โดยตรง
    var totalPrice = order['total_amount'] != null
        ? double.parse(order['total_amount'].toString())
        : 0.0;

    return Container(
      child: InkWell(
        onTap: () => Get.to(() => OrderDetails(data: order)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order ${order['order_id'] ?? 'Unknown'}")
                      .text
                      .size(16)
                      .fontFamily(medium)
                      .make(),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: greyDark),
                      const SizedBox(width: 10),
                      Text(intl.DateFormat().add_yMd().format(time)),
                    ],
                  ),
                ],
              ),
              ...buildProductList(order['orders']),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Total: ${NumberFormat('#,##0.00').format(totalPrice)} Bath",
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: medium,
                      color: greyDark,
                    ),
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 8, vertical: 6),
        ),
      )
          .box
          .white
          .margin(const EdgeInsets.symmetric(vertical: 8))
          .outerShadow
          .border(color: greyLine)
          .rounded
          .make(),
    );
  }

  List<Widget> buildProductList(List orders) {
    if (orders == null) return [Text('No products available')];

    return orders.map<Widget>((order) {
      var qty = order['qty'] != null ? order['qty'] : 0;
      var productId = order['product_id'] != null ? order['product_id'] : '';

      return FutureBuilder<Map<String, dynamic>>(
        future: getProductDetails(productId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var productDetails = snapshot.data!;
          var img = productDetails['imageUrl'] ?? '';
          var title = productDetails['name'] ?? 'Unknown';
          var price =
              productDetails['price'] != null ? productDetails['price'] : 0.0;

          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Text("${qty}x",
                    style: const TextStyle(fontSize: 14, fontFamily: regular)),
                const SizedBox(width: 5),
                Image.network(img, width: 65, height: 70, fit: BoxFit.cover),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style:
                              const TextStyle(fontSize: 16, fontFamily: medium),
                          overflow: TextOverflow.ellipsis),
                      Text(
                        "${NumberFormat('#,##0').format(price)} Bath",
                      )
                          .text
                          .size(14)
                          .fontFamily(regular)
                          .color(greyColor)
                          .make(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }).toList();
  }
}

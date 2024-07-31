import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/products_screen/items_details.dart';
import 'package:seller_finalproject/views/widgets/appbar_widget.dart';
import 'package:seller_finalproject/views/widgets/dashboard_button.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

double calculateTotalOrderAmount(List<DocumentSnapshot> vendorOrders) {
  return vendorOrders.fold<double>(0, (sum, doc) {
    var orderData = doc.data() as Map<String, dynamic>;
    return sum + (double.tryParse(orderData['total_amount'].toString()) ?? 0);
  });
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedPeriod = 'All Time';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: /* appbarWidget(dashboard) */ AppBar(
          title: Text('Dashboard').text.size(24).fontFamily(semiBold).make()),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> productSnapshot) {
          if (!productSnapshot.hasData) {
            return loadingIndicator();
          } else {
            var productsData = productSnapshot.data!.docs;

            // Filter products by current vendor
            var vendorProducts = productsData
                .where((doc) => doc['vendor_id'] == currentUser!.uid)
                .toList();

            // Sort productsData by wishlist length in descending order
            vendorProducts.sort((a, b) =>
                b['favorite_uid'].length.compareTo(a['favorite_uid'].length));

            return StreamBuilder(
              stream: StoreServices.getOrders(currentUser!.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                if (!orderSnapshot.hasData) {
                  return loadingIndicator();
                } else {
                  var ordersData = orderSnapshot.data!.docs;

                  // Filter orders by current vendor
                  var vendorOrders = ordersData
                      .where((doc) => doc['vendor_id'] == currentUser!.uid)
                      .toList();

                  var filterOrdersByDateRange = (DateTime start, DateTime end) {
                    return vendorOrders.where((order) {
                      var orderData = order.data() as Map<String, dynamic>?;
                      var orderDate = orderData != null &&
                              orderData.containsKey('created_at')
                          ? (orderData['created_at'] as Timestamp).toDate()
                          : null;
                      return orderDate != null &&
                          orderDate.isAfter(start) &&
                          orderDate.isBefore(end);
                    }).toList();
                  };

                  var today = DateTime.now();
                  var startOfToday =
                      DateTime(today.year, today.month, today.day);
                  var startOfYesterday =
                      startOfToday.subtract(Duration(days: 1));
                  var startOfWeek =
                      startOfToday.subtract(Duration(days: today.weekday - 1));
                  var startOfLastWeek = startOfWeek.subtract(Duration(days: 7));
                  var startOfMonth = DateTime(today.year, today.month, 1);
                  var startOfLastMonth =
                      DateTime(today.year, today.month - 1, 1);
                  var startOfYear = DateTime(today.year, 1, 1);

                  List<DocumentSnapshot> orders;
                  switch (selectedPeriod) {
                    case 'Today':
                      orders = filterOrdersByDateRange(
                              startOfToday, startOfToday.add(Duration(days: 1)))
                          .cast<DocumentSnapshot>();
                      break;
                    case 'Yesterday':
                      orders = filterOrdersByDateRange(
                              startOfYesterday, startOfToday)
                          .cast<DocumentSnapshot>();
                      break;
                    case 'This Week':
                      orders = filterOrdersByDateRange(
                              startOfWeek, startOfToday.add(Duration(days: 1)))
                          .cast<DocumentSnapshot>();
                      break;
                    case 'Last Week':
                      orders =
                          filterOrdersByDateRange(startOfLastWeek, startOfWeek)
                              .cast<DocumentSnapshot>();
                      break;
                    case 'This Month':
                      orders = filterOrdersByDateRange(
                              startOfMonth, startOfToday.add(Duration(days: 1)))
                          .cast<DocumentSnapshot>();
                      break;
                    case 'Last Month':
                      orders = filterOrdersByDateRange(
                              startOfLastMonth, startOfMonth)
                          .cast<DocumentSnapshot>();
                      break;
                    case 'This Year':
                      orders = filterOrdersByDateRange(
                              startOfYear, startOfToday.add(Duration(days: 1)))
                          .cast<DocumentSnapshot>();
                      break;
                    default:
                      orders = vendorOrders.cast<DocumentSnapshot>();
                  }

                  int totalSales = orders
                      .where((order) =>
                          order['order_confirmed'] == true &&
                          order['order_delivered'] == true &&
                          order['order_on_delivery'] == true &&
                          order['order_placed'] == true)
                      .length;
                  double totalPrice = calculateTotalOrderAmount(orders
                      .where((order) => order['order_delivered'] == true)
                      .toList());

                  int undeliveredOrdersCount = orders
                      .where((order) => order['order_delivered'] == false)
                      .length;
                  int deliveredOrdersCount = orders
                      .where((order) => order['order_delivered'] == true)
                      .length;
                  double totalOrderAmount = calculateTotalOrderAmount(orders
                      .where((order) => order['order_delivered'] == true)
                      .toList());

                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              intl.DateFormat('EEE,MMM d ' 'yyyy')
                                  .format(DateTime.now()),
                            )
                                .text
                                .size(14)
                                .fontFamily(medium)
                                .color(greyDark,)
                                .make(),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 130,
                                height: 35,
                                decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          10.0), 
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedPeriod,
                                      items: <String>[
                                        'Today',
                                        'Yesterday',
                                        'This Week',
                                        'Last Week',
                                        'This Month',
                                        'Last Month',
                                        'This Year',
                                        'All Time'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedPeriod = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ).box.white.outerShadow.roundedSM.make(),
                            )
                          ],
                        ).marginSymmetric(horizontal: 20),
                        10.heightBox,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            dashboardButton(context,
                                title: products,
                                count: "${productsData.length}",
                                icon: icProducts),
                            5.heightBox,
                            Row(
                              children: [
                                Expanded(
                                  child: dashboardButton(
                                    context,
                                    title: ordersdas,
                                    count: "$undeliveredOrdersCount",
                                    icon: icOrders,
                                  ),
                                ),
                                10.widthBox,
                                Expanded(
                                  child: dashboardButton(
                                    context,
                                    title: totalSale,
                                    count: "$deliveredOrdersCount",
                                    icon: icTotalsales,
                                  ),
                                ),
                              ],
                            ),
                            5.heightBox,
                            dashboardButton(context,
                                title: 'Total Price',
                                count: '${NumberFormat('#,##0').format(totalOrderAmount)} Bath',
                                icon: icTotalPrice)
                          ],
                        )
                            .box
                            .padding(EdgeInsets.symmetric(horizontal: 10))
                            .make(),
                        const Divider(color: greyLine),
                        10.heightBox,
                        Align(
                                alignment: Alignment.topLeft,
                                child: Text(popular)
                                    .text
                                    .size(20)
                                    .fontFamily(semiBold)
                                    .make())
                            .paddingOnly(left: 20),
                        10.heightBox,
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: vendorProducts.length > 10
                                ? 10
                                : vendorProducts.length,
                            itemBuilder: (context, index) {
                              var productSnapshot = vendorProducts[index];
                              var productData = productSnapshot.data()
                                  as Map<String, dynamic>;
                              productData['documentId'] = productSnapshot.id;

                              if (productData['favorite_uid'].isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Get.to(() =>
                                          ItemsDetails(data: productData));
                                    },
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(height: 20),
                                            Text("${index + 1}.")
                                                .text
                                                .size(16)
                                                .fontFamily(medium)
                                                .color(greyDark)
                                                .make(),
                                          ],
                                        ),
                                        SizedBox(width: 10),
                                        Image.network(
                                          vendorProducts[index]['imgs'][0],
                                          width: 55,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(width: 10),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(vendorProducts[index]
                                                      ['name'])
                                                  .text
                                                  .size(16)
                                                  .fontFamily(medium)
                                                  .make(),
                                              Text(
                                                "${NumberFormat('#,##0').format(double.tryParse(vendorProducts[index]['price'])?.toInt() ?? 0)} Bath",
                                              )
                                                  .text
                                                  .size(14)
                                                  .color(greyColor)
                                                  .fontFamily(medium)
                                                  .make(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(color: greyLine)
                                      .paddingSymmetric(horizontal: 12),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/products_screen/product_details.dart';
import 'package:seller_finalproject/views/widgets/appbar_widget.dart';
import 'package:seller_finalproject/views/widgets/dashboard_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(dashboard),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> productSnapshot) {
          if (!productSnapshot.hasData) {
            return loadingIndicator();
          } else {
            var productsData = productSnapshot.data!.docs;
            productsData = productsData.sortedBy((a, b) => a['p_wishlist'].length.compareTo(b['p_wishlist'].length));

            return StreamBuilder(
              stream: StoreServices.getOrders(currentUser!.uid),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                if (!orderSnapshot.hasData) {
                  return loadingIndicator();
                } else {
                  var ordersData = orderSnapshot.data!.docs;
                  var totalProductsInOrders = ordersData.length;

                  // ตรวจสอบและนับจำนวนการขายทั้งหมดที่มีทุกฟิลด์เป็น true
                  var totalSales = ordersData.where((order) =>
                    order['order_confirmed'] == true &&
                    order['order_delivered'] == true &&
                    order['order_on_delivery'] == true &&
                    order['order_placed'] == true
                  ).length;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            dashboardButton(context,
                                title: products,
                                count: "${productsData.length}",
                                icon: icProducts),
                            dashboardButton(context,
                                title: orders,
                                count: "$totalProductsInOrders",
                                icon: icOrders)
                          ],
                        ),
                        10.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            dashboardButton(context,
                                title: rating, count: 60, icon: icStar),
                            dashboardButton(context,
                                title: totalSale, count: totalSales.toString(), icon: icOrders) // แสดงจำนวนการขายทั้งหมด
                          ],
                        ),
                        10.heightBox,
                        const Divider(color: thinGrey0),
                        20.heightBox,
                        Text(popular),
                        10.heightBox,
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: productsData.length,
                            itemBuilder: (context, index) {
                              if (productsData[index]['p_wishlist'].isEmpty) {
                                return const SizedBox.shrink(); // Use shrink for more semantically correct empty space
                              }
                              return ListTile(
                                onTap: () async {
                                  var productSnapshot = await FirebaseFirestore.instance
                                      .collection('products')
                                      .where('p_name', isEqualTo: productsData[index]['p_name'])
                                      .get();

                                  if (productSnapshot.docs.isNotEmpty) {
                                    var productData = productSnapshot.docs.first.data();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetails(data: productData),
                                      ),
                                    );
                                  } else {
                                    // Handle product not found
                                  }
                                },
                                leading: Image.network(
                                  productsData[index]['p_imgs'][0],
                                  width: 60,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(productsData[index]['p_name']).text.size(16).fontFamily(medium).make(),
                                subtitle: Text(
                                  "${NumberFormat('#,##0').format(double.tryParse(productsData[index]['p_price'])?.toInt() ?? 0)} Bath",
                                ),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';
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
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> productSnapshot) {
          if (!productSnapshot.hasData) {
            return loadingIndicator();
          } else {
            var productsData = productSnapshot.data!.docs;

            // Sort productsData by wishlist length in descending order
            productsData.sort((a, b) =>
                b['p_wishlist'].length.compareTo(a['p_wishlist'].length));

            return StreamBuilder(
              stream: StoreServices.getOrders(currentUser!.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                if (!orderSnapshot.hasData) {
                  return loadingIndicator();
                } else {
                  var ordersData = orderSnapshot.data!.docs;
                  var totalProductsInOrders = ordersData.length;

                  var totalSales = ordersData
                      .where((order) =>
                          order['order_confirmed'] == true &&
                          order['order_delivered'] == true &&
                          order['order_on_delivery'] == true &&
                          order['order_placed'] == true)
                      .length;

                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            dashboardButton(context,
                                title: products,
                                count: "${productsData.length}",
                                icon: icProducts),
                            5.heightBox,
                            dashboardButton(context,
                                title: orders,
                                count: "$totalProductsInOrders",
                                icon: icOrders),
                            5.heightBox,
                            dashboardButton(context,
                                title: totalSale,
                                count: totalSales.toString(),
                                icon: icTotalsales)
                          ],
                        )
                            .box
                            .padding(EdgeInsets.symmetric(horizontal: 18))
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
                            itemCount: productsData.length > 10
                                ? 10
                                : productsData.length,
                            itemBuilder: (context, index) {
                              if (productsData[index]['p_wishlist'].isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      var productSnapshot =
                                          await FirebaseFirestore.instance
                                              .collection('products')
                                              .where('p_name',
                                                  isEqualTo: productsData[index]
                                                      ['p_name'])
                                              .get();

                                      if (productSnapshot.docs.isNotEmpty) {
                                        var productData =
                                            productSnapshot.docs.first.data();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                                    data: productData),
                                          ),
                                        );
                                      } else {
                                        // Handle product not found
                                      }
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
                                          productsData[index]['p_imgs'][0],
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
                                              Text(productsData[index]
                                                      ['p_name'])
                                                  .text
                                                  .size(16)
                                                  .fontFamily(medium)
                                                  .make(),
                                              Text(
                                                "${NumberFormat('#,##0').format(double.tryParse(productsData[index]['p_price'])?.toInt() ?? 0)} Bath",
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

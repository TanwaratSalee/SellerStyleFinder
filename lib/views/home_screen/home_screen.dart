import 'package:cloud_firestore/cloud_firestore.dart';
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
                b['favorite_uid'].length.compareTo(a['favorite_uid'].length));

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
                              var productSnapshot = productsData[index];
                              var productData = productSnapshot.data()
                                  as Map<String, dynamic>;
                              productData['documentId'] =
                                  productSnapshot.id; // Add this line

                              if (productData['favorite_uid'].isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      // Navigate to the ItemDetails page with the product data
                                      Get.to(() => ItemsDetails(
                                          data:
                                              productData)); // Pass the updated data
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
                                          productsData[index]['imgs'][0],
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
                                              Text(productsData[index]['name'])
                                                  .text
                                                  .size(16)
                                                  .fontFamily(medium)
                                                  .make(),
                                              Text(
                                                "${NumberFormat('#,##0').format(double.tryParse(productsData[index]['price'])?.toInt() ?? 0)} Bath",
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

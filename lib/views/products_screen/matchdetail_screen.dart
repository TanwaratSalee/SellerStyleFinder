import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/views/products_screen/items_details.dart'; // Import the ProductDetails screen

class MatchDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? topProduct = Get.arguments['topProduct'];
    final Map<String, dynamic>? lowerProduct = Get.arguments['lowerProduct'];
    final String? description = Get.arguments['description'];
    final dynamic sex = Get.arguments['sex']; // Changed to dynamic to handle both String and List
    final dynamic collection = Get.arguments['collection']; // Changed to dynamic to handle both String and List

    // Ensure sex and collection are strings
    final String sexString = sex is List ? sex.join(', ') : sex.toString();
    final String collectionString = collection is List ? collection.join(', ') : collection.toString();

    if (topProduct == null || lowerProduct == null || description == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Match Details")),
        body: Center(
          child: Text('Invalid match data'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Match Details")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  var productSnapshot = await FirebaseFirestore.instance
                                      .collection('products')
                                      .doc(topProduct['product_id']) // Use the ID of the top product
                                      .get();

                                  if (productSnapshot.exists) {
                                    var productData = productSnapshot.data();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ItemsDetails(data: productData),
                                      ),
                                    );
                                  } else {
                                    Get.snackbar('Error', 'Product not found', snackPosition: SnackPosition.BOTTOM);
                                  }
                                },
                                child: Container(
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(14),
                                        topLeft: Radius.circular(14),
                                      ),
                                      child: Image.network(
                                        topProduct['img'],
                                        height: 150,
                                        width: 165,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              5.heightBox,
                              SizedBox(
                                width: 130,
                                child: Text(
                                  topProduct['name'],
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: greyDark,
                                    fontSize: 14,
                                    fontFamily: semiBold,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              Text(
                                "${NumberFormat('#,##0').format(double.tryParse(topProduct['price'].toString()) ?? 0)} Bath",
                              ).text.color(greyDark).fontFamily(regular).size(12).make(),
                            ],
                          ).box.border(color: greyLine).rounded.make(),
                        ),
                        const SizedBox(width: 5),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              color: whiteColor,
                            ).box.color(primaryApp).roundedFull.padding(EdgeInsets.all(4)).make(),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  var productSnapshot = await FirebaseFirestore.instance
                                      .collection('products')
                                      .doc(lowerProduct['product_id']) // Use the ID of the lower product
                                      .get();

                                  if (productSnapshot.exists) {
                                    var productData = productSnapshot.data();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ItemsDetails(data: productData),
                                      ),
                                    );
                                  } else {
                                    Get.snackbar('Error', 'Product not found', snackPosition: SnackPosition.BOTTOM);
                                  }
                                },
                                child: Container(
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(14),
                                        topLeft: Radius.circular(14),
                                      ),
                                      child: Image.network(
                                        lowerProduct['img'],
                                        height: 150,
                                        width: 165,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              5.heightBox,
                              SizedBox(
                                width: 130,
                                child: Text(
                                  lowerProduct['name'],
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: greyDark,
                                    fontSize: 14,
                                    fontFamily: semiBold,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              Text(
                                "${NumberFormat('#,##0').format(double.tryParse(lowerProduct['price'].toString()) ?? 0)} Bath",
                              ).text.color(greyDark).fontFamily(regular).size(12).make(),
                            ],
                          ).box.border(color: greyLine).rounded.make(),
                        ),
                      ],
                    ),
                    30.heightBox,
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Suitable for gender',
                          ).text.fontFamily(regular).size(16).make(),
                        ),
                        Column(
                          children: [
                            SizedBox(height: 10),
                            Container(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: sexString.split(', ').length,
                                itemBuilder: (context, index) {
                                  String item = sexString.split(', ')[index];
                                  String capitalizedItem = item[0].toUpperCase() + item.substring(1);
                                  return Container(
                                    alignment: Alignment.center,
                                    child: capitalizedItem.text.size(14).color(greyDark).fontFamily(medium).make(),
                                  ).box.color(thinPrimaryApp).margin(EdgeInsets.symmetric(horizontal: 6)).roundedLg.padding(EdgeInsets.symmetric(horizontal: 24, vertical: 12)).make();
                                },
                              ),
                            ),
                          ],
                        ),
                        10.heightBox,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Opportunity suitable for',
                          ).text.fontFamily(regular).size(16).make(),
                        ),
                        Column(
                          children: [
                            SizedBox(height: 10),
                            Container(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: collectionString.split(', ').length,
                                itemBuilder: (context, index) {
                                  String item = collectionString.split(', ')[index];
                                  return Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${item[0].toUpperCase()}${item.substring(1)}",
                                    ).text.size(14).color(greyDark).fontFamily(medium).make(),
                                  ).box.color(thinPrimaryApp).margin(EdgeInsets.symmetric(horizontal: 6)).roundedLg.padding(EdgeInsets.symmetric(horizontal: 24, vertical: 12)).make();
                                },
                              ),
                            ),
                          ],
                        ),
                        10.heightBox,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'The reason for match',
                            style: TextStyle(
                              fontFamily: regular,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: greyThin,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                description,
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 12)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

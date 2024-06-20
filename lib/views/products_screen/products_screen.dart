import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/products_screen/add_match.dart';
import 'package:seller_finalproject/views/products_screen/add_product.dart';
import 'package:seller_finalproject/views/products_screen/edit_match.dart';
import 'package:seller_finalproject/views/products_screen/edit_product.dart';
import 'package:seller_finalproject/views/products_screen/matchdetail_screen.dart';
import 'package:seller_finalproject/views/products_screen/items_details.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final searchController = TextEditingController();
  var controller = Get.put(ProductsController());
  final String vendorId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Product')
                .text
                .size(24)
                .fontFamily(medium)
                .makeCentered(),
            bottom: const TabBar(
              labelColor: primaryApp,
              unselectedLabelColor: greyColor,
              indicatorColor: primaryApp,
              tabs: [
                Tab(text: 'Product'),
                Tab(text: 'Match'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              buildProductsTab(context),
              buildMatchesTab(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductsTab(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: StoreServices.getProducts(vendorId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return loadingIndicator();
        }
        var data = snapshot.data!.docs;
        return Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.add,
                color: greyDark,
                size: 28,
              ),
              title: const Text(
                'Add new product',
                style: TextStyle(color: greyDark),
              ),
              onTap: () async {
                await controller.getCollection();
                controller.populateCollectionList();
                Get.to(() => const AddProduct());
              },
            ),
            Divider(
              color: greyLine,
            ).paddingSymmetric(horizontal: 14),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var doc = data[index].data() as Map<String, dynamic>;
                  String documentId = data[index].id;
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          print('Navigating to ItemsDetails with data: $doc');
                          Get.to(() => ItemsDetails(data: doc));
                        },
                        leading: doc['imgs'] != null && doc['imgs'].isNotEmpty
                            ? Image.network(
                                doc['imgs'][0],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/placeholder.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                        title: Text(
                          doc['name'],
                          style: TextStyle(
                            color: blackColor,
                            fontSize: 16,
                            fontFamily: medium,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          "${NumberFormat('#,##0').format(double.tryParse(doc['price'])?.toInt() ?? 0)} Bath",
                          style: TextStyle(
                            color: greyColor,
                            fontSize: 14,
                            fontFamily: medium,
                          ),
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            color: greyColor,
                          ),
                          onSelected: (String value) {
                            if (value == 'edit') {
                              print(
                                  'Navigating to EditProduct with data: $doc');
                              Get.to(() => EditProduct(
                                  productData: doc, documentId: documentId));
                            } else if (value == 'delete') {
                              controller.removeProduct(documentId);
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                                value: 'edit', child: Text('Edit')),
                            const PopupMenuItem<String>(
                                value: 'delete', child: Text('Delete')),
                          ],
                        ),
                      ),
                      Divider(
                        color: greyLine,
                      ).paddingSymmetric(horizontal: 14),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildMatchesTab(BuildContext context) {
    final String currentUserUID = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('storemixandmatchs')
          .where('vendor_id', isEqualTo: currentUserUID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final documents = snapshot.data!.docs;
        return ListView.builder(
          itemCount: documents.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ListTile(
                leading: const Icon(
                  Icons.add,
                  color: blackColor,
                  size: 28,
                ),
                title: const Text(
                  'Add new match',
                  style: TextStyle(color: blackColor),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddMatchProduct()),
                  );
                },
              );
            }

            var document = documents[index - 1];
            String productIdTop = document['product_id_top'];
            String productIdLower = document['product_id_lower'];

            return Column(
              children: [
                FutureBuilder(
                  future: Future.wait([
                    FirebaseFirestore.instance
                        .collection('products')
                        .doc(productIdTop)
                        .get(),
                    FirebaseFirestore.instance
                        .collection('products')
                        .doc(productIdLower)
                        .get(),
                  ]),
                  builder: (context,
                      AsyncSnapshot<List<DocumentSnapshot>> productSnapshot) {
                    if (!productSnapshot.hasData) {
                      return ListTile(
                        title: Text('Loading product details...'),
                      );
                    }

                    var topProductData =
                        productSnapshot.data![0].data() as Map<String, dynamic>;
                    var lowerProductData =
                        productSnapshot.data![1].data() as Map<String, dynamic>;

                    return Stack(
                      children: [
                        ListTile(
                          title: Column(
                            children: [
                              Row(
                                children: [
                                  topProductData['imgs'] != null &&
                                          topProductData['imgs'].isNotEmpty
                                      ? Image.network(
                                          topProductData['imgs'][0],
                                          width: 65,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        )
                                      : loadingIndicator(),
                                  15.widthBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(topProductData['name']).text.fontFamily(medium).size(16).make(),
                                      "${NumberFormat('#,##0').format(double.parse(topProductData['price']).toInt())} Bath".text.fontFamily(medium).size(14).color(greyColor).make()
                                    ],
                                  ),
                                ],
                              ),
                              5.heightBox,
                              Row(
                                children: [
                                  lowerProductData['imgs'] != null &&
                                          lowerProductData['imgs'].isNotEmpty
                                      ? Image.network(
                                          lowerProductData['imgs'][0],
                                          width: 65,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        )
                                      : loadingIndicator(),
                                  15.widthBox,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(lowerProductData['name']).text.fontFamily(medium).size(16).make(),
                                      "${NumberFormat('#,##0').format(double.parse(lowerProductData['price']).toInt())} Bath".text.fontFamily(medium).size(14).color(greyColor).make()
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        
                          onTap: () {
                            Get.to(
                              () => MatchDetailsScreen(),
                              arguments: {
                                'topProduct': {
                                  'product_id': document['product_id_top'],
                                  'img': topProductData['imgs']?.first ?? '',
                                  'name': topProductData['name'] ?? '',
                                  'price': topProductData['price'] ?? 0,
                                },
                                'lowerProduct': {
                                  'product_id': document['product_id_lower'],
                                  'img': lowerProductData['imgs']?.first ?? '',
                                  'name': lowerProductData['name'] ?? '',
                                  'price': lowerProductData['price'] ?? 0,
                                },
                                'description': document['description'] ?? '',
                                'sex': document['gender'] ?? '',
                                'collection': document['collection'] ?? '',
                              },
                            );
                          },
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              color: greyColor,
                            ),
                            onSelected: (String value) {
                              if (value == 'edit') {
                                Get.to(() => EditMatchProduct(), arguments: {
                                  'document': document,
                                  'ItemsDetails': {
                                    'topProduct': topProductData,
                                    'lowerProduct': lowerProductData,
                                  }
                                });
                              } else if (value == 'delete') {
                                controller.removeMatch(document.id);
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                  value: 'edit', child: Text('Edit')),
                              const PopupMenuItem<String>(
                                  value: 'delete', child: Text('Delete')),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Divider(
                  color: greyLine,
                ),
              ],
            );
          },
        );
      },
    );
  }
}


//  Widget buildMatchesTab(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('products')
//           .where('vendor_id', isEqualTo: vendorId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return loadingIndicator();
//         }

//         if (!snapshot.hasData) {
//           return const Center(child: Text("No matches found."));
//         }

//         Map<String, List<DocumentSnapshot>> mixMatchMap = {};

//         for (var doc in snapshot.data!.docs) {
//           var data = doc.data() as Map<String, dynamic>;
//           if (data['vendor_id'] == vendorId && data['mixmatch'] != null) {
//             String mixMatchKey = data['mixmatch'];
//             mixMatchMap.putIfAbsent(mixMatchKey, () => []).add(doc);
//           }
//         }

//         var validPairs = mixMatchMap.entries
//             .where((entry) => entry.value.length == 2)
//             .toList();

//         if (validPairs.isEmpty) {
//           return Column(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.add),
//                 title: const Text('Add new match'),
//                 onTap: () async {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AddMatchProduct()),
//                   );
//                 },
//               ),
//               const Center(child: Text("No valid matches to display."))
//             ],
//           );
//         }

//         return Column(
//           children: [
//             ListTile(
//               leading: const Icon(
//                 Icons.add,
//                 color: greyDark,
//                 size: 28,
//               ),
//               title: const Text(
//                 'Add new match',
//                 style: TextStyle(color: greyDark),
//               ),
//               onTap: () async {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AddMatchProduct()),
//                 );
//               },
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: validPairs.length,
//                 itemBuilder: (context, index) {
//                   var pair = validPairs[index];
//                   var product1 = pair.value[0].data() as Map<String, dynamic>;
//                   var product2 = pair.value[1].data() as Map<String, dynamic>;

//                   String documentId1 = pair.value[0].id;
//                   String documentId2 = pair.value[1].id;
//                   String price1 = product1['price'].toString();
//                   String price2 = product2['price'].toString();
//                   String name1 = product1['name'].toString();
//                   String name2 = product2['name'].toString();

//                   String productImage1 = product1['imgs'][0];
//                   String productImage2 = product2['imgs'][0];

//                   return Column(
//                     children: [
//                       Row(
//                         children: [
//                           Image.network(
//                             productImage1,
//                             width: 65,
//                             height: 70,
//                             fit: BoxFit.cover,
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('$name1').text.size(16).medium.make(),
//                                 2.heightBox,
//                                 Text("${NumberFormat('#,##0').format(double.parse(price1.toString()).toInt())} Bath")
//                                     .text
//                                     .light
//                                     .make(),
//                               ],
//                             ),
//                           ),
                          // PopupMenuButton<String>(
                          //   icon: Icon(
                          //     Icons.more_vert,
                          //     color: greyColor ,
                          //   ),
                          //   onSelected: (String value) {
                          //     if (value == 'edit') {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => EditMatchProduct(
                          //                 product1: product1,
                          //                 product2: product2)),
                          //       );
                          //     } else if (value == 'delete') {
                          //       controller.resetMixMatchData(pair.value[0].id);
                          //       controller.resetMixMatchData(pair.value[1].id);
                          //     }
                          //   },
                          //   itemBuilder: (BuildContext context) =>
                          //       <PopupMenuEntry<String>>[
                          //     const PopupMenuItem<String>(
                          //         value: 'edit', child: Text('Edit')),
                          //     const PopupMenuItem<String>(
                          //         value: 'delete', child: Text('Delete')),
                          //   ],
                          // ),
//                         ],
//                       ),
//                       5.heightBox,
//                       Row(
//                         children: [
//                           Image.network(
//                             productImage2,
//                             width: 65,
//                             height: 70,
//                             fit: BoxFit.cover,
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('$name2').text.size(16).medium.make(),
//                                 2.heightBox,
//                                 Text("${NumberFormat('#,##0').format(double.parse(price2.toString()).toInt())} Bath")
//                                     .text
//                                     .light
//                                     .make(),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       10.heightBox,
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           const Text('Total ').text.fontFamily(regular).make(),
//                           5.widthBox,
//                           Text("${NumberFormat('#,##0').format((double.parse(price1.toString()) + double.parse(price2.toString())).toInt())} Bath")
//                               .text
//                               .fontFamily(regular)
//                               .make(),
//                         ],
//                       ),
//                       Divider(color: greyLine),
//                     ],
//                   )
//                       .box
//                       .margin(const EdgeInsets.symmetric(
//                           vertical: 4, horizontal: 12))
//                       .padding(const EdgeInsets.symmetric(
//                           vertical: 8, horizontal: 12))
//                       .make();
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

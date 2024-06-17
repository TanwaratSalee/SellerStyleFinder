import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
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
import 'package:seller_finalproject/views/products_screen/product_details.dart';

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
                          print(controller.productId);
                          Get.to(() => ProductDetails(data: doc));
                        },
                        leading: Image.network(
                          doc['p_imgs'][0],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          doc['p_name'],
                          style: TextStyle(
                            color: blackColor,
                            fontSize: 16,
                            fontFamily: medium,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          "${NumberFormat('#,##0').format(double.tryParse(doc['p_price'])?.toInt() ?? 0)} Bath",
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
                              Get.to(() => EditProduct(
                                  productData: doc, documentId: documentId));
                              print(controller.productId);
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
  Future<Map<String, dynamic>> fetchProductDetails(String topId, String lowerId) async {
    final topSnapshot = await FirebaseFirestore.instance.collection('products').doc(topId).get();
    final lowerSnapshot = await FirebaseFirestore.instance.collection('products').doc(lowerId).get();

    final topName = topSnapshot.exists ? topSnapshot.data()!['p_name'] : 'Unknown';
    final lowerName = lowerSnapshot.exists ? lowerSnapshot.data()!['p_name'] : 'Unknown';
    final topImg = topSnapshot.exists ? topSnapshot.data()!['p_imgs'][0] : '';
    final lowerImg = lowerSnapshot.exists ? lowerSnapshot.data()!['p_imgs'][0] : '';
    final topPrice = topSnapshot.exists ? double.tryParse(topSnapshot.data()!['p_price'].toString()) : 0.0;
    final lowerPrice = lowerSnapshot.exists ? double.tryParse(lowerSnapshot.data()!['p_price'].toString()) : 0.0;

    return {
      'p_name_top': topName,
      'p_name_lower': lowerName,
      'p_img_top': topImg,
      'p_img_lower': lowerImg,
      'p_price_top': topPrice,
      'p_price_lower': lowerPrice,
    };
  }

  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('storemixandmatchs').snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMatchProduct()),
                );
              },
            );
          }

          var document = documents[index - 1];

          return FutureBuilder(
            future: fetchProductDetails(document['p_id_top'], document['p_id_lower']),
            builder: (context, AsyncSnapshot<Map<String, dynamic>> productSnapshot) {
              if (!productSnapshot.hasData) {
                return ListTile(
                  title: Center(child: CircularProgressIndicator())
                );
              }
              final productDetails = productSnapshot.data!;

              String imgTop = productDetails['p_img_top'].toString();
              String nameTop = productDetails['p_name_top'].toString();
              double priceTop = double.parse(productDetails['p_price_top'].toString());
              String imgLower = productDetails['p_img_lower'].toString();
              String nameLower = productDetails['p_name_lower'].toString();
              double priceLower = double.parse(productDetails['p_price_lower'].toString());

              // แปลงข้อมูล List เป็น String ถ้าจำเป็น
              var description = document['p_desc'];
              if (description is List) {
                description = description.join(', ');
              }
              var sex = document['p_sex'];
              if (sex is List) {
                sex = sex.join(', ');
              }
              var collection = document['p_collection'];
              if (collection is List) {
                collection = collection.join(', ');
              }

              return Stack(
                children: [
                  Column(
                    children: [
                      ListTile(
                        subtitle: GestureDetector(
                          onTap: () {
                            // Navigate to MatchDetailsScreen
                            Get.to(() => MatchDetailsScreen(), arguments: {
                              'topProduct': {
                                'img': imgTop,
                                'name': nameTop,
                                'price': priceTop,
                              },
                              'lowerProduct': {
                                'img': imgLower,
                                'name': nameLower,
                                'price': priceLower,
                              },
                              'description': description,
                              'sex': sex,
                              'collection': collection,
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    imgTop.isNotEmpty 
                                      ? Image.network(
                                          imgTop,
                                          width: 60,
                                          height: 65,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 60,
                                          height: 65,
                                          color: greyColor,
                                          child: Center(child: Text("ImgTop")),
                                        ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              nameTop,
                                              style: TextStyle(fontSize: 16, fontFamily: medium, color: blackColor),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text("${NumberFormat('#,##0').format(priceTop)} Bath", style: TextStyle(fontSize: 14, fontFamily: regular, color: greyColor)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    imgLower.isNotEmpty 
                                      ? Image.network(
                                          imgLower,
                                          width: 60,
                                          height: 65,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 60,
                                          height: 65,
                                          color: greyColor,
                                          child: Center(child: Text("ImgLower")),
                                        ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              nameLower,
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text("${NumberFormat('#,##0').format(priceLower)} Bath", style: TextStyle(fontWeight: FontWeight.w300)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(color: greyLine), // เส้นกั้นระหว่างแต่ละ ListTile
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: greyColor,
                      ),
                      onSelected: (String result) async {
                        if (result == 'edit') {
                          // ส่งข้อมูลไปหน้า EditMatchProduct เพื่อแก้ไขข้อมูล
                          Get.to(() => EditMatchProduct(), arguments: {
                            'document': document,
                            'productDetails': productDetails,
                          });
                        } else if (result == 'delete') {
                          // ลบเอกสารจาก Firestore
                          await FirebaseFirestore.instance.collection('storemixandmatchs').doc(document.id).delete();
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
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
//           if (data['vendor_id'] == vendorId && data['p_mixmatch'] != null) {
//             String mixMatchKey = data['p_mixmatch'];
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
//                   String price1 = product1['p_price'].toString();
//                   String price2 = product2['p_price'].toString();
//                   String name1 = product1['p_name'].toString();
//                   String name2 = product2['p_name'].toString();

//                   String productImage1 = product1['p_imgs'][0];
//                   String productImage2 = product2['p_imgs'][0];

//                   return Column(
//                     children: [
//                       Row(
//                         children: [
//                           Image.network(
//                             productImage1,
//                             width: 60,
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
//                           PopupMenuButton<String>(
//                             icon: Icon(
//                               Icons.more_vert,
//                               color: greyColor ,
//                             ),
//                             onSelected: (String value) {
//                               if (value == 'edit') {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => EditMatchProduct(
                                //           product1: product1,
                                //           product2: product2)),
                                // );
//                               } else if (value == 'delete') {
//                                 controller.resetMixMatchData(pair.value[0].id);
//                                 controller.resetMixMatchData(pair.value[1].id);
//                               }
//                             },
//                             itemBuilder: (BuildContext context) =>
//                                 <PopupMenuEntry<String>>[
//                               const PopupMenuItem<String>(
//                                   value: 'edit', child: Text('Edit')),
//                               const PopupMenuItem<String>(
//                                   value: 'delete', child: Text('Delete')),
//                             ],
//                           ),
//                         ],
//                       ),
//                       5.heightBox,
//                       Row(
//                         children: [
//                           Image.network(
//                             productImage2,
//                             width: 60,
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

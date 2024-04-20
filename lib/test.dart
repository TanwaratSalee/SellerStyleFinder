import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
// import 'package:seller_finalproject/controllers/loading_indicator.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/products_screen/add_match.dart';
import 'package:seller_finalproject/views/products_screen/add_product.dart';
import 'package:seller_finalproject/views/products_screen/edit_product.dart';
import 'package:seller_finalproject/views/products_screen/product_details.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

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
      length: 2, // Total number of tabs
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: primaryApp,
        //   onPressed: () async {
        //     await controller.getCollection();
        //     controller.populateCollectionList();
        //     Get.to(() => const AddProduct());
        //   },
        //   child: const Icon(Icons.add, color: whiteColor),
        // ),
        appBar: AppBar(
          title: const Text('Products'),
          bottom: const TabBar(
            labelColor: primaryApp,
            unselectedLabelColor: greyColor,
            indicatorColor: primaryApp,
            tabs: [
              Tab(text: 'Products'),
              Tab(text: 'Matches'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextField(
            //     controller: searchController,
            //     decoration: InputDecoration(
            //       labelText: 'Search',
            //       hintText: 'Search for products...',
            //       prefixIcon: const Icon(Icons.search),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(25.0),
            //       ),
            //     ),
            //     onChanged: (value) {
            //       // Implement your search functionality here
            //     },
            //   ),
            // ),
            Expanded(
              child: TabBarView(
                children: [
                  // First tab content
                  StreamBuilder<QuerySnapshot>(
                    stream: StoreServices.getProducts(currentUser!.uid),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return loadingIndicator();
                      }
                      var data = snapshot.data!.docs;
                      return Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.add),
                            title: const Text('Add new product'),
                            onTap: () async {
                              await controller.getCollection();
                              controller.populateCollectionList();
                              Get.to(() => const AddProduct());
                            },
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                var doc =
                                    data[index].data() as Map<String, dynamic>;
                                bool isFeatured = doc['is_featured']
                                        .toString()
                                        .toLowerCase() == 'true';

                                return ListTile(
                                  onTap: () =>
                                      Get.to(() => ProductDetails(data: doc)),
                                  leading: Image.network(
                                    doc['p_imgs'][0],
                                    width: 50,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(doc['p_name'])
                                      .text
                                      .size(16)
                                      .fontFamily(medium)
                                      .make(),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                          "${NumberFormat('#,##0').format(double.tryParse(doc['p_price'])?.toInt() ?? 0)} Bath"),
                                      const SizedBox(width: 10),
                                      // if (isFeatured) Text("Featured"),
                                    ],
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    onSelected: (String value) {
                                      String docId = data[index].id;
                                      if (value == 'edit') {
                                        Get.to(
                                              () => EditProduct(productData: doc, documentId: data[index].id,),
                                            );

                                      } else if (value == 'delete') {
                                        controller.removeProduct(docId);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                                    icon: Icon(Icons.more_vert), // Icon for the button
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // Second tab content
                  Center(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('Add new match'),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMatchProduct()),
                        );
                      },
                    ),
            Expanded(
              child: TabBarView(
                children: [
                  // Products Tab
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where('vendor_id', isEqualTo: vendorId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return loadingIndicator();
                      }

                      Map<String, List<DocumentSnapshot>> mixMatchMap = {};

                      for (var doc in snapshot.data!.docs) {
                        var data = doc.data() as Map<String, dynamic>;
                        if (data['vendor_id'] == vendorId && data['p_mixmatch'] != null) {
                          String mixMatchKey = data['p_mixmatch'];
                          mixMatchMap.putIfAbsent(mixMatchKey, () => []).add(doc);
                        }
                      }
                      // Filter groups with more than one entry
                      var validPairs = mixMatchMap.entries
                          .where((entry) => entry.value.length == 2)
                          .toList();

                      return ListView.builder(
                        itemCount: validPairs.length,
                        itemBuilder: (context, index) {
                          var pair = validPairs[index];
                          var product1 = pair.value[0].data() as Map<String, dynamic>;
                          var product2 = pair.value[1].data() as Map<String, dynamic>;

                          String price1 = product1['p_price'].toString();
                          String price2 = product2['p_price'].toString();

                          String name1 = product1['p_name'].toString();
                          String name2 = product2['p_name'].toString();

                          String productImage1 = product1['p_imgs'][0];
                          String productImage2 = product2['p_imgs'][0];

                          return ListTile(
                            // leading: Image.network(productImage1, width: 50, height: 50, fit: BoxFit.cover),
                            // trailing: Image.network(productImage2, width: 50, height: 50, fit: BoxFit.cover),
                            // title: Text('Product 1: ${product1['p_name']} - Product 2: ${product2['p_name']}'),
                            // subtitle: Text("Product 1 Price: ${product1['p_price']} Bath - Product 2 Price: ${price1} Bath"),
                            // onTap: () => Get.to(() => ProductDetails(data: pair)),
                          );
                        },
                      );
                    },
                  ),
                  // Matches Tab (Assuming this needs similar updates or remains unchanged)
                ],
              ),
            ),
                  ],
                ),
              )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
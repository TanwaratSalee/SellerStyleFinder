import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/products_screen/add_match.dart';
import 'package:seller_finalproject/views/products_screen/add_product.dart';
import 'package:seller_finalproject/views/products_screen/edit_product.dart';
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Products').text.size(24).fontFamily(medium).make(),
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
        body: TabBarView(
          children: [
            buildProductsTab(context),
            buildMatchesTab(context),
          ],
        ),
      ),
    );
  }

  Widget buildProductsTab(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: StoreServices.getProducts(FirebaseAuth.instance.currentUser!.uid),
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
                  var doc = data[index].data() as Map<String, dynamic>;
                  return ListTile(
                    onTap: () => Get.to(() => ProductDetails(data: doc)),
                    leading: Image.network(
                      doc['p_imgs'][0],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(doc['p_name']),
                    subtitle: Text(
                      "${NumberFormat('#,##0').format(double.tryParse(doc['p_price'])?.toInt() ?? 0)} Bath",
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == 'edit') {
                          Get.to(() => EditProduct(
                              productData: doc, documentId: data[index].id));
                        } else if (value == 'delete') {
                          controller.removeProduct(data[index].id);
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('vendor_id', isEqualTo: vendorId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingIndicator();
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("No matches found."));
        }

        Map<String, List<DocumentSnapshot>> mixMatchMap = {};

        for (var doc in snapshot.data!.docs) {
          var data = doc.data() as Map<String, dynamic>;
          if (data['vendor_id'] == vendorId && data['p_mixmatch'] != null) {
            String mixMatchKey = data['p_mixmatch'];
            mixMatchMap.putIfAbsent(mixMatchKey, () => []).add(doc);
          }
        }

        var validPairs = mixMatchMap.entries
            .where((entry) => entry.value.length == 2)
            .toList();

        if (validPairs.isEmpty) {
          return Column(
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add new match'),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddMatchProduct()),
                  );
                },
              ),
              const Center(child: Text("No valid matches to display."))
            ],
          );
        }

        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add new match'),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddMatchProduct()),
                );
              },
            ),
            Expanded(
              child: ListView.builder(
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

                  return Column(
                    children: [
                      Row(
                        children: [
                          Image.network(
                            productImage1,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$name1').text.size(16).medium.make(),
                                2.heightBox,
                                Text("${NumberFormat('#,##0').format(double.parse(price1.toString()).toInt())} Bath")
                                    .text
                                    .light
                                    .make(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      5.heightBox,
                      Row(
                        children: [
                          Image.network(
                            productImage2,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('$name2').text.size(16).medium.make(),
                                2.heightBox,
                                Text("${NumberFormat('#,##0').format(double.parse(price2.toString()).toInt())} Bath")
                                    .text
                                    .light
                                    .make(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      10.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Total price:').text.fontFamily(regular).make(),
                          5.widthBox,
                          Text("${NumberFormat('#,##0').format((double.parse(price1.toString()) + double.parse(price2.toString())).toInt())} Bath")
                              .text
                              .fontFamily(regular)
                              .make(),
                        ],
                      ),
                    ],
                  )
                      .box
                      .rounded
                      .border(color: thinGrey01)
                      .margin(const EdgeInsets.symmetric(vertical: 4, horizontal: 12))
                      .padding(
                          const EdgeInsets.symmetric(vertical: 8, horizontal: 12))
                      .make();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

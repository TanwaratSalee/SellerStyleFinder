import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
// import 'package:seller_finalproject/controllers/loading_indicator.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/products_screen/add_product.dart';
import 'package:seller_finalproject/views/products_screen/product_details.dart';
import 'package:seller_finalproject/views/widgets/appbar_widget.dart';
import 'package:seller_finalproject/views/widgets/text_style.dart';
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Total number of tabs
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryApp,
          onPressed: () async {
            await controller.getCollection();
            controller.populateCollectionList();
            Get.to(() => const AddProduct());
          },
          child: const Icon(Icons.add, color: whiteColor),
        ),
        appBar: AppBar(
          title: const Text('Products'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Products'),
              Tab(text: 'Matches'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search for products...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onChanged: (value) {
                  // Implement your search functionality here
                },
              ),
            ),
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
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var doc = data[index];
                          return ListTile(
                            onTap: () =>
                                Get.to(() => ProductDetails(data: doc)),
                            leading: Image.network(
                              doc['p_imgs'][0],
                              width: 50,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            title: boldText(
                                text: doc['p_name'], color: fontGreyDark),
                            subtitle: Row(
                              children: [
                                normalText(
                                    text: "${doc['p_price']}", color: fontGrey),
                                const SizedBox(width: 10),
                                if (doc['is_featured'])
                                  boldText(text: "Featured", color: primaryApp),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Second tab content
                  Center(
                    child: Text("Match content goes here"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget loadingIndicator() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

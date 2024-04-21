import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';

import '../../const/colors.dart';

class MatchDetailScreen extends StatefulWidget {
  final String productName1;
  final String productName2;
  final String price1;
  final String price2;
  final String productImage1;
  final String productImage2;
  final String totalPrice;

  const MatchDetailScreen({
    this.productName1 = '',
    this.productName2 = '',
    this.price1 = '',
    this.price2 = '',
    this.productImage1 = '',
    this.productImage2 = '',
    this.totalPrice = '',
  });

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  bool isFavorited = false;
  late final ProductsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProductsController());
    // checkIsInWishlist();
  }

  // void checkIsInWishlist() async {
  //   FirebaseFirestore.instance
  //       .collection(productsCollection)
  //       .where('p_name', whereIn: [widget.productName1, widget.productName2])
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //         if (querySnapshot.docs.isNotEmpty) {
  //           querySnapshot.docs.forEach((doc) {
  //             List<dynamic> wishlist = doc['p_wishlist'] ?? [];
  //             if (wishlist.contains(currentUser!.uid)) {
  //               controller.isFav(true);
  //             } else {
  //               controller.isFav(false);
  //             }
  //           });
  //         }
  //       });
  // }

  // void _updateIsFav(bool isFav) {
  //   setState(() {
  //     controller.isFav.value = isFav;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text(
          'Match Product',
          style: TextStyle(fontFamily: regular, fontSize: 32),
        ),
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios),
        //   onPressed: () => Get.back(),
        // ),
        elevation: 0,
        actions: <Widget>[
          // Obx(
          //   () => IconButton(
          //     onPressed: () {
          //       setState(() {
          //         List<String> productNames = [
          //           widget.productName1,
          //           widget.productName2
          //         ];
          //         bool isFav =
          //             !controller.isFav.value; // Toggle the isFav value
          //         productNames.forEach((productName) {
          //           if (isFav == true) {
          //             controller.addToWishlistMixMatch(
          //                 productName, _updateIsFav, context);
          //           }
          //           if (isFav == false) {
          //             controller.removeToWishlistMixMatch(
          //                 productName, _updateIsFav, context);
          //           }
          //         });
          //         print("isFav after toggling: $isFav"); // Debug print
          //       });
          //     },
          //     icon: Icon(
          //       controller.isFav.value
          //           ? Icons.favorite
          //           : Icons.favorite_outline,
          //       color: controller.isFav.value ? redColor : null,
          //     ),
          //     iconSize: 28,
          //   ),
          // ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 40, 8, 0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 230,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      // border: Border.all(color: greyColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    'assets/images/product3.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hello',
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: blackColor,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                '5555 Bath',
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: blackColor,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: primaryApp,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: whiteColor,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 180,
                    height: 230,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      // border: Border.all(color: greyColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(
                                    'assets/images/product4.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hello',
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: blackColor,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                '5555 Bath',
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: blackColor,
                                  fontSize: 20,
                                ),
                              ),
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
          const SizedBox(height: 25),
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 229, 235, 237),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: whiteColor,
                              image: DecorationImage(
                                image: AssetImage('assets/icons/LogoOnApp.jpg'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DIOR',
                      style: TextStyle(
                        fontFamily: regular,
                        color: blackColor,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      '⭐ 4.9/5',
                      style: TextStyle(
                        fontFamily: regular,
                        color: blackColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 100,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      // Get.to(() => StoreScreen());
                    },
                    child: const Text(
                      'See Store',
                      style: TextStyle(
                        fontFamily: regular,
                        color: whiteColor,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryApp,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Opportunity suitable for',
                          style: TextStyle(
                            fontFamily: regular,
                            color: blackColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            for (String label in [
                              'Everyday',
                              'Dating',
                              'Seminars or meetings',
                            ])
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 229, 235, 237),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      color: primaryApp,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: [
                    Text(
                      'The reason for this match',
                      style: TextStyle(
                        fontFamily: regular,
                        color: blackColor,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 229, 235, 237),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Choosing a simple shirt with a high-waisted mini or long skirt can create a comfortable but still stylish look.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: regular,
                          color: blackColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


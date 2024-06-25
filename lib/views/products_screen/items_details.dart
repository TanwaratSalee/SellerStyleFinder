import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/products_controller.dart';
import 'package:seller_finalproject/views/profile_screen/review_screen.dart';

class ItemsDetails extends StatelessWidget {
  final dynamic data;
  final ProductsController controller = Get.put(ProductsController());

  ItemsDetails({Key? key, required this.data}) : super(key: key);

  Future<Map<String, String>> getUserDetails(String userId) async {
    if (userId.isEmpty) {
      debugPrint('Error: userId is empty.');
      return {'name': 'Unknown User', 'id': userId, 'imageUrl': ''};
    }

    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>?;
        debugPrint('User data: $userData');
        return {
          'name': userData?['name'] ?? 'Unknown User',
          'id': userId,
          'imageUrl': userData?['imageUrl'] ?? ''
        };
      } else {
        debugPrint('User not found for ID: $userId');
        return {'name': 'Unknown User', 'id': userId, 'imageUrl': ''};
      }
    } catch (e) {
      debugPrint('Error getting user details: $e');
      return {'name': 'Unknown User', 'id': userId, 'imageUrl': ''};
    }
  }

  Future<void> fetchProductReviewsAndRatings(String productId) async {
    // Fetch reviews
    var reviewsSnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('product_id', isEqualTo: productId)
        .get();

    // Check if there are reviews
    if (reviewsSnapshot.docs.isNotEmpty) {
      // Calculate average rating
      var totalRating = reviewsSnapshot.docs
          .fold<double>(0.0, (sum, doc) => sum + doc['rating']);
      controller.averageRating.value =
          totalRating / reviewsSnapshot.docs.length;
      controller.reviewCount.value = reviewsSnapshot.docs.length;
    } else {
      controller.averageRating.value = 0.0;
      controller.reviewCount.value = 0;
    }

    // Update reviews in controller
    controller.reviews.assignAll(reviewsSnapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    String documentId = data['documentId'];
    print('Received data: ${data['name']} and document ID: $documentId');

    // Load reviews and ratings
    fetchProductReviewsAndRatings(documentId);

    return Scaffold(
      appBar: AppBar(
        title: Text(data['name'] ?? 'Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data['imgs'] != null && data['imgs'].isNotEmpty)
                VxSwiper.builder(
                  autoPlay: true,
                  height: 420,
                  itemCount: data['imgs'].length,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                  itemBuilder: (context, index) {
                    return Image.network(
                      data['imgs'][index] ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              10.heightBox,
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'] ?? 'No Name',
                      style: const TextStyle(
                        color: blackColor,
                        fontFamily: semiBold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      data['aboutProduct'] ?? 'No description available',
                      style: TextStyle(
                        fontFamily: regular,
                        color: greyDark,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "${NumberFormat('#,##0').format(double.tryParse(data['price']?.toString() ?? '0')?.toInt() ?? 0)} Bath",
                      style: TextStyle(
                        color: primaryApp,
                        fontFamily: medium,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (data['collection'] != null &&
                        data['collection'].isNotEmpty)
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Collection"
                                .text
                                .color(blackColor)
                                .size(16)
                                .fontFamily(medium)
                                .make(),
                            SizedBox(height: 5),
                            Container(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data['collection'].length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: Text(
                                      "${data['collection'][index].toString()[0].toUpperCase()}${data['collection'][index].toString().substring(1)}",
                                    )
                                        .text
                                        .size(26)
                                        .color(blackColor)
                                        .fontFamily(medium)
                                        .make(),
                                  )
                                      .box
                                      .white
                                      .color(thinPrimaryApp)
                                      .margin(
                                          EdgeInsets.symmetric(horizontal: 3))
                                      .roundedLg
                                      .padding(EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12))
                                      .make();
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            "Description"
                                .text
                                .color(blackColor)
                                .size(16)
                                .fontFamily(medium)
                                .make(),
                            SizedBox(height: 5),
                            Text(data['description'] ?? 'No description')
                                .text
                                .color(blackColor)
                                .size(12)
                                .fontFamily(regular)
                                .make(),
                            SizedBox(height: 15),
                            "Size & Fit"
                                .text
                                .color(blackColor)
                                .size(16)
                                .fontFamily(medium)
                                .make(),
                            SizedBox(height: 5),
                            Text(data['size'] ?? 'No size information')
                                .text
                                .color(blackColor)
                                .size(12)
                                .fontFamily(regular)
                                .make(),
                          ],
                        )
                            .box
                            .white
                            .padding(const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 18))
                            .margin(const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 7))
                            .outerShadow
                            .roundedSM
                            .make(),
                      ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Product rating')
                                      .text
                                      .fontFamily(medium)
                                      .size(18)
                                      .color(blackColor)
                                      .make(),
                                  Obx(() {
                                    double rating =
                                        controller.averageRating.value;
                                    int reviewCount =
                                        controller.reviewCount.value;
                                    return Row(
                                      children: [
                                        buildCustomRating(rating, 20),
                                        SizedBox(width: 8),
                                        Text(
                                          '${rating.toStringAsFixed(1)}/5.0 ($reviewCount reviews)',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: blackColor,
                                            fontFamily: medium,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(
                                    () => ReviewScreen(productId: documentId));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('See All')
                                      .text
                                      .fontFamily(medium)
                                      .size(14)
                                      .color(blackColor)
                                      .make(),
                                  10.widthBox,
                                  Image.asset(
                                    icSeeAll,
                                    width: 12,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).box.padding(EdgeInsets.symmetric(vertical: 5)).make(),
                        Divider(color: greyThin),
                        Obx(() {
                          var reviews = controller.reviews;
                          if (reviews.isEmpty) {
                            return Center(
                                child: Text(
                                        'The product has not been reviewed yet.')
                                    .text
                                    .size(16)
                                    .color(greyColor)
                                    .make());
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: reviews.length,
                            itemBuilder: (context, index) {
                              var review = reviews[index];
                              var reviewData =
                                  review.data() as Map<String, dynamic>;
                              var timestamp =
                                  reviewData['created_at'] as Timestamp;
                              var date = DateFormat('yyyy-MM-dd')
                                  .format(timestamp.toDate());
                              var rating = reviewData['rating'] is double
                                  ? (reviewData['rating'] as double).toInt()
                                  : reviewData['rating'] as int;

                              print('Product ID: ${reviewData['product_id']}');

                              return FutureBuilder<Map<String, String>>(
                                future: getUserDetails(reviewData['user_id']),
                                builder: (context, userSnapshot) {
                                  if (!userSnapshot.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  var userDetails = userSnapshot.data!;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              userDetails['imageUrl'] ??
                                                  'https://via.placeholder.com/150',
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      child: Text(
                                                        userDetails['name'] ??
                                                            'Not Found',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                semiBold,
                                                            fontSize: 16),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Text(
                                                      date,
                                                      style: TextStyle(
                                                          color: greyColor,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    buildStars(rating ?? 0),
                                                    5.widthBox,
                                                    Text(
                                                        '${rating.toString()}/5.0'),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  reviewData['review_text'] ??
                                                      'No review text',
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                          .box
                                          .padding(EdgeInsets.only(left: 55))
                                          .make(),
                                    ],
                                  )
                                      .box
                                      .padding(EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 8))
                                      .make();
                                },
                              );
                            },
                          );
                        }),
                      ],
                    )
                        .box
                        .padding(EdgeInsets.all(12))
                        .white
                        .outerShadow
                        .roundedSM
                        .make(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.yellow,
          size: 16,
        );
      }),
    );
  }

  Widget buildCustomRating(double rating, double size) {
    int filledStars = rating.floor();
    bool hasHalfStar = rating - filledStars > 0;

    return Row(
      children: List.generate(5, (index) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.star_border,
              color: Colors.yellow,
              size: size,
            ),
            Icon(
              Icons.star,
              color: index < filledStars ? Colors.yellow : Colors.transparent,
              size: size - 2,
            ),
          ],
        ).marginOnly(right: 4);
      }),
    );
  }
}

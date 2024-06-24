import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:intl/intl.dart' as intl;

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchReviews() async {
    QuerySnapshot reviewSnapshot = await _firestore.collection('reviews').get();
    List<Map<String, dynamic>> reviews = reviewSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    for (var review in reviews) {
      // Fetch user details
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(review['user_id']).get();
      review['user_name'] = userSnapshot['name'];
      review['user_image'] = userSnapshot['imageUrl'];

      // Fetch product details
      DocumentSnapshot productSnapshot = await _firestore
          .collection('products')
          .doc(review['product_id'])
          .get();
      review['product_name'] = productSnapshot['name'];
      // Assuming 'imgs' is a list, get the first image for display
      review['product_image'] = productSnapshot['imgs'][0];
    }

    return reviews;
  }

  void showReviewDialog(BuildContext context, Map<String, dynamic> review) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: 420,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(10), // Set border radius here
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Code: ${review['order_id'] ?? 'Null'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: medium,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Image.network(
                          review['product_image'],
                          width: 80,
                          height: 85,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: SizedBox(
                            width: 80,
                            child: Text(
                              '${review['product_name']}',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: regular,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                review['user_image'],
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            10.widthBox,
                            Column(
                              children: [
                                Text(review['user_name']).text.size(16).make(),
                                Row(
                                  children: [
                                    Text('Date : '),
                                    Text(intl.DateFormat().add_yMd().format(
                                        (review['created_at'].toDate()))),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        10.widthBox,
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: review['rating'].toDouble(),
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: golden,
                              ),
                              itemCount: 5,
                              itemSize: 20,
                              direction: Axis.horizontal,
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${review['rating']}/5',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: regular,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 200,
                          child: Text(
                            review['review_text']  ?? 'Null',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            // overflow: TextOverflow.ellipsis,
                            maxLines: null,
                          ),
                        )
                            .box
                            .color(greyMessage)
                            .padding(EdgeInsets.all(12))
                            .rounded
                            .make()
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text(
          'Reviews',
          style: TextStyle(fontSize: 24, fontFamily: semiBold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: loadingIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No reviews found'));
          } else {
            List<Map<String, dynamic>> reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                var review = reviews[index];
                return GestureDetector(
                  onTap: () => showReviewDialog(context, review),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyLine),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 85,
                              height: 90,
                              child: Image.network(
                                review['product_image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          15.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order Code : ${review['order_id']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: regular,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${review['product_name']}',
                                  style: const TextStyle(
                                    fontFamily: medium,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ).box.width(220).make(),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating:
                                          (review['rating'] as num).toDouble(),
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: golden,
                                      ),
                                      itemCount: 5,
                                      itemSize: 25,
                                      direction: Axis.horizontal,
                                    ),
                                    5.widthBox,
                                    Text('${review['rating']}/5')
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart' as intl;
import 'package:seller_finalproject/const/const.dart';

class AllReviewScreen extends StatefulWidget {
  final String vendorId;

  AllReviewScreen({required this.vendorId});

  @override
  _AllReviewScreenState createState() => _AllReviewScreenState();
}

class _AllReviewScreenState extends State<AllReviewScreen>
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
    QuerySnapshot reviewSnapshot = await _firestore
        .collection('reviews')
        .where('vendor_id', isEqualTo: widget.vendorId)
        .get();

    List<Map<String, dynamic>> reviews = reviewSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    List<Map<String, dynamic>> filteredReviews = [];

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
      review['product_image'] = productSnapshot['imgs'][0];
      review['product_vendor_id'] = productSnapshot['vendor_id'];
      print('product_vendor_id: ${review['product_vendor_id']}'); // พิมพ์ค่า product_vendor_id

      // Check if product vendor_id matches the vendorId in widget
      if (review['product_vendor_id'] == widget.vendorId) {
        filteredReviews.add(review);
      }
    }

    return filteredReviews;
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
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
                        fontFamily: 'Medium',
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
                                fontFamily: 'Regular',
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
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(review['user_name']),
                                Row(
                                  children: [
                                    Text('Date: '),
                                    Text(intl.DateFormat().add_yMd().format(
                                        (review['created_at'] as Timestamp)
                                            .toDate())),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: (review['rating'] as num).toDouble(),
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20,
                              direction: Axis.horizontal,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '${review['rating']}/5',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Regular',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 200,
                          child: Text(
                            review['review_text'] ?? 'No review text',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            maxLines: null,
                          ),
                        ).box.padding(EdgeInsets.all(12)).white.rounded.make()
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Reviews',
          style: TextStyle(fontSize: 24, fontFamily: 'SemiBold'),
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
            return Center(child: CircularProgressIndicator());
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
                        border: Border.all(color: Colors.grey),
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
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order Code: ${review['order_id']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Regular',
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${review['product_name']}',
                                  style: const TextStyle(
                                    fontFamily: 'Medium',
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating:
                                          (review['rating'] as num).toDouble(),
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 25,
                                      direction: Axis.horizontal,
                                    ),
                                    SizedBox(width: 5),
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

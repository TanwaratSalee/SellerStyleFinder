import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';

class ItemsDetails extends StatelessWidget {
  final dynamic data;

  const ItemsDetails({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    if (data['collection'] != null && data['collection'].isNotEmpty)
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Collection".text.color(blackColor).size(16).fontFamily(medium).make(),
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
                                    ).text.size(26).color(blackColor).fontFamily(medium).make(),
                                  ).box.white.color(thinPrimaryApp).margin(EdgeInsets.symmetric(horizontal: 3)).roundedLg.padding(EdgeInsets.symmetric(horizontal: 24, vertical: 12)).make();
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            "Description".text.color(blackColor).size(16).fontFamily(medium).make(),
                            SizedBox(height: 5),
                            Text(data['description'] ?? 'No description').text.color(blackColor).size(12).fontFamily(regular).make(),
                            SizedBox(height: 15),
                            "Size & Fit".text.color(blackColor).size(16).fontFamily(medium).make(),
                            SizedBox(height: 5),
                            Text(data['size'] ?? 'No size information').text.color(blackColor).size(12).fontFamily(regular).make(),
                          ],
                        ).box.white.padding(const EdgeInsets.symmetric(horizontal: 22, vertical: 18)).margin(const EdgeInsets.symmetric(horizontal: 2, vertical: 7)).outerShadow.roundedSM.make(),
                      ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Product rating').text.fontFamily(medium).size(18).color(blackColor).make(),
                                  // Add your rating display logic here
                                ],
                              ),
                            ),
                            InkWell(
                              // onTap: () {
                              //   Get.to(() => ReviewScreen(productId: controller.documentId.value));
                              // },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('See All').text.fontFamily(medium).size(14).color(blackColor).make(),
                                  10.widthBox,
                                  Image.asset(icSeeAll, width: 12),
                                ],
                              ),
                            ),
                          ],
                        ).box.padding(EdgeInsets.symmetric(vertical: 5)).make(),
                        Divider(color: greyThin),
                        Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('reviews').where('id').snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                var reviews = snapshot.data!.docs;
                                if (reviews.isEmpty) {
                                  return Center(
                                    child: Text('The product has not been reviewed yet.').text.size(16).color(greyColor).make(),
                                  );
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: reviews.length > 3 ? 3 : reviews.length,
                                  itemBuilder: (context, index) {
                                    var review = reviews[index];
                                    var timestamp = review['review_date'] as Timestamp;
                                    var date = DateFormat('yyyy-MM-dd').format(timestamp.toDate());
                                    var rating = review['rating'] is double ? (review['rating'] as double).toInt() : review['rating'] as int;
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(review['user_img'] ?? ''),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: 150, // Limit the width to 150 pixels
                                                        child: Text(
                                                          review['user_name'] ?? 'Anonymous',
                                                          style: TextStyle(fontFamily: semiBold, fontSize: 16),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis, // Truncate with ellipsis if it exceeds the width
                                                        ),
                                                      ),
                                                      Text(
                                                        date,
                                                        style: TextStyle(color: greyColor, fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      buildStars(rating),
                                                      5.widthBox,
                                                      Text('${rating.toStringAsFixed(1)}/5.0')
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
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    review['review_text'] ?? 'No review text',
                                                    style: TextStyle(fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ).box.padding(EdgeInsets.only(left: 55)).make(),
                                      ],
                                    ).box.padding(EdgeInsets.symmetric(vertical: 14, horizontal: 8)).make();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ).box.padding(EdgeInsets.all(12)).margin(const EdgeInsets.symmetric(horizontal: 2, vertical: 7)).white.outerShadow.roundedSM.make(),
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

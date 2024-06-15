import 'package:intl/intl.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;

  const ProductDetails({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(data['p_name'] ?? 'Product'),
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VxSwiper.builder(
                autoPlay: true,
                height: 420,
                itemCount: data['p_imgs'].length,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                itemBuilder: (context, index) {
                  return Image.network(
                    data['p_imgs'][index] ?? '',
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                      child: Text(
                        data['p_name'] ?? 'No Name',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: medium,
                        ),
                      ),
                    ),
                    5.heightBox,

                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            "${data['p_collection'] ?? ''}",
                            style: TextStyle(
                                color: greyColor,
                                fontSize: 14,
                                fontFamily: medium),
                          ),
                          10.widthBox,
                          Text("${data['p_subcollection'] ?? ''}",
                              style: TextStyle(
                                  color: greyColor,
                                  fontSize: 1,
                                  fontFamily: medium))
                        ],
                      ),
                    ),
                    10.heightBox,

                    // VxRating(
                    //   isSelectable: false,
                    //   // value: 3.0,
                    //   value: double.parse(data["p_rating"]),
                    //   onRatingUpdate: (value) {},
                    //   normalColor: greyColor,
                    //   selectionColor: golden,
                    //   count: 5,
                    //   size: 25,
                    //   maxRating: 5,
                    // ),
                    // 10.heightBox,
                    // ignore: unnecessary_string_escapes
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        // "${data['p_price'] ?? ''} Bath",
                        "${NumberFormat('#,##0').format(double.parse(data['p_price']).toInt())} Bath",

                        style: TextStyle(
                            color: primaryApp,
                            fontFamily: medium,
                            fontSize: 20),
                      ),
                    ),
                    10.heightBox,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: greyMessage,
                            spreadRadius: 1.5,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage('URL ของรูปภาพ'),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Shop Name',
                              style: TextStyle(
                                color: greyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryApp,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Text(
                              'See Store',
                              style: TextStyle(
                                fontFamily: medium,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.heightBox,

                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: greyMessage,
                            spreadRadius: 1.5,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   children: [
                              //     const SizedBox(
                              //       width: 100,
                              //       child: Text(
                              //         "Color: ",
                              //       ),
                              //     ),
                              //     Row(
                              //       children: List.generate(
                              //         data['p_colors'].length,
                              //         (index) => VxBox()
                              //             .size(30, 30)
                              //             .roundedFull
                              //             .color(Color(data['p_colors'][index]))
                              //             //.color(Color(data['p_colors'][index]).withOpacity(1.0))
                              //             .margin(
                              //                 const EdgeInsets.symmetric(horizontal: 4))
                              //             .make()
                              //             .onTap(() {}),
                              //       ),
                              //     ),
                              //   ],
                              // ).box.padding(const EdgeInsets.all(8)).make(),

                              // //quantity row
                              // Row(
                              //   children: [
                              //     const SizedBox(
                              //       width: 100,
                              //       child: Text("Quantity: "),
                              //     ),
                              //     Text(
                              //       "${data['p_quantity'] ?? ''} items",
                              //     ),
                              //   ],
                              // ).box.padding(const EdgeInsets.all(8)).make(),
                              // Row(
                              //   children: [
                              //     const SizedBox(
                              //       width: 100,
                              //       child: Text("Size : "),
                              //     ),
                              //     Text("${data['p_productsize'] ?? ''}"),
                              //   ],
                              // ).box.padding(const EdgeInsets.all(8)).make(),

                              // const Divider(color: greyThin),
                              10.heightBox,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text(
                                      "Collection : ",
                                      style: TextStyle(
                                          fontFamily: medium, fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryDark,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: Text(
                                            'Summer',
                                            style: TextStyle(
                                              fontFamily: medium,
                                              color: greyDark,
                                            ),
                                          ),
                                        ),
                                        5.widthBox,
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryDark,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: Text(
                                            'Winter',
                                            style: TextStyle(
                                              fontFamily: medium,
                                              color: greyDark,
                                            ),
                                          ),
                                        ),
                                        5.widthBox,
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryDark,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          child: Text(
                                            'Autumn',
                                            style: TextStyle(
                                              fontFamily: medium,
                                              color: greyDark,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              10.heightBox,
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: const Text(
                                  "Description :",
                                  style: TextStyle(
                                      fontFamily: medium, fontSize: 16),
                                ),
                              ),
                              10.heightBox,
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(data['p_desc'] ?? ''),
                              ),
                            ]),
                      ),
                    ),
                    10.heightBox,

                    Container(
                      width: double.infinity,
                      height: 350,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: greyMessage,
                            spreadRadius: 1.5,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Product Rating",
                                      style: TextStyle(
                                          fontFamily: medium, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 95,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                child: Text(
                                  " 5/5",
                                  style: TextStyle(
                                      fontFamily: medium, fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                                child: VxRating(
                                  isSelectable: false,
                                  value: double.parse(data["p_rating"]),
                                  onRatingUpdate: (value) {},
                                  normalColor: greyColor,
                                  selectionColor: golden,
                                  count: 5,
                                  size: 25,
                                  maxRating: 5,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: greyThin),
                          SizedBox(
                            height: 250,
                          ),
                          const Divider(
                            color: greyThin,
                          ),
                          Center(
                            child: Text(
                              "See all",
                              style:
                                  TextStyle(fontFamily: medium, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/views/widgets/text_style.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;
  const ProductDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: boldText(text: "${data['p_name']}", color: fontGrey, size: 16.0),
      ),
      body: SingleChildScrollView(
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
                  // imgProduct,
                  data['p_imgs'][index],
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
            10.heightBox,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  boldText(text: "${data['p_name']}", color: fontBlack, size: 20.0),
                  5.heightBox,

                  Row(
                    children: [
                      boldText(text: "${data['p_collection']}", color: fontGrey, size: 16),
                      10.widthBox,
                      normalText(text: "${data['p_subcollection']}", color: fontGrey)
                    ],
                  ),
                  10.heightBox,

                  VxRating(
                    isSelectable: false,
                    // value: 3.0,
                    value: double.parse(data["p_rating"]),
                    onRatingUpdate: (value) {},
                    normalColor: fontGrey,
                    selectionColor: golden,
                    count: 5,
                    size: 25,
                    maxRating: 5,
                  ),
                  10.heightBox,
                  // ignore: unnecessary_string_escapes
                  boldText(text: "${data['p_price']} Bath", color: primaryApp, size: 18.0),
                  10.heightBox,
                  Column(children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: boldText(text: "Color: ", color: fontGrey),
                        ),
                        Row(
                          children: List.generate(
                              data['p_colors'].length,
                              (index) => 
                                      VxBox()
                                          .size(30, 30)
                                          .roundedFull
                                          .color(Color(data['p_colors'][index]))
                                          // .color(Color(data['p_colors'][index]).withOpacity(1.0))
                                          .margin(const EdgeInsets.symmetric(
                                              horizontal: 4))
                                          .make()
                                          .onTap(() {}),
                                    
                                  ),
                        ),
                      ],
                    ).box.padding(const EdgeInsets.all(8)).make(),

                    //quantity row
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: boldText(text: "Quantity: ", color: fontGrey),
                        ),
                        normalText (text: "${data['p_quantity']} items", color: fontGrey),
                      ],
                    ).box.padding(const EdgeInsets.all(8)).make(),

                    const Divider(),

                    10.heightBox,
                    boldText(text: "Description", color: fontGrey),
                    10.heightBox,
                    normalText(text: "${data['p_desc']}", color: fontGrey),
                    
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

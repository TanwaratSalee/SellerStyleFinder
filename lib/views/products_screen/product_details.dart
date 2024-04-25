import 'package:seller_finalproject/const/const.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;

  const ProductDetails({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['p_name'] ?? 'Product'),
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
                  data['p_imgs'][index] ?? '',
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
                  Text(data['p_name'] ?? 'No Name'),
                  5.heightBox,

                  Row(
                    children: [
                      Text("${data['p_collection'] ?? ''}"),
                      10.widthBox,
                      Text("${data['p_subcollection'] ?? ''}",)
                    ],
                  ),
                  10.heightBox,

                  VxRating(
                    isSelectable: false,
                    // value: 3.0,
                    value: double.parse(data["p_rating"]),
                    onRatingUpdate: (value) {},
                    normalColor: greyColor,
                    selectionColor: golden,
                    count: 5,
                    size: 25,
                    maxRating: 5,
                  ),
                  10.heightBox,
                  // ignore: unnecessary_string_escapes
                  Text("${data['p_price'] ?? ''} Bath"),
                  10.heightBox,
                  Column(children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Text("Color: ", ),
                        ),
                        Row(
                          children: List.generate(
                              data['p_colors'].length,
                              (index) => 
                                      VxBox()
                                          .size(30, 30)
                                          .roundedFull
                                          .color(Color(data['p_colors'][index]))
                                          //.color(Color(data['p_colors'][index]).withOpacity(1.0))
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
                        const SizedBox(
                          width: 100,
                          child: Text("Quantity: "),
                        ),
                        Text ("${data['p_quantity'] ?? ''} items"),
                      ],
                    ).box.padding(const EdgeInsets.all(8)).make(),
                    Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Text("Size : "),
                        ),
                        Text("${data['p_productsize'] ?? ''}"),
                      ],
                    ).box.padding(const EdgeInsets.all(8)).make(),
                    const Divider(),
                    10.heightBox,
                    const Text("Description", ),
                    10.heightBox,
                    Text(data['p_desc'] ?? ''),
                    
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

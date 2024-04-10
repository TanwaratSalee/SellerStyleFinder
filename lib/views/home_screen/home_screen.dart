import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/products_screen/product_details.dart';
import 'package:seller_finalproject/views/widgets/appbar_widget.dart';
import 'package:seller_finalproject/views/widgets/dashboard_button.dart';
import 'package:seller_finalproject/views/widgets/text_style.dart';
// ignore: unused_import, depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(dashboard),
      body: StreamBuilder(
          stream: StoreServices.getProducts(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndcator();
            } else {
              var data = snapshot.data!.docs;
              data = data.sortedBy((a, b) =>
                  a['p_wishlist'].length.compareTo(b['p_wishlist'].length));

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        dashboardButton(context,
                            title: products,
                            count: "${data.length}",
                            icon: icProducts),
                        dashboardButton(context,
                            title: orders, count: 15, icon: icOrders)
                      ],
                    ),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        dashboardButton(context,
                            title: rating, count: 60, icon: icStar),
                        dashboardButton(context,
                            title: totalSales, count: 15, icon: icOrders)
                      ],
                    ),
                    10.heightBox,
                    const Divider(),
                    20.heightBox,
                    boldText(text: popular, color: fontGreyDark, size: 16.0),
                    10.heightBox,
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                          data.length,
                          (index) => data[index]['p_wishlist'].length == 0
                              ? const SizedBox()
                              : ListTile(
                                  onTap: () {
                                    Get.to(() =>
                                        ProductDetails(data: data[index]));
                                  },
                                  leading: Image.network(
                                    data[index]['p_imgs'][0],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  title: boldText(
                                      text: "${data[index]['p_name']}",
                                      color: fontGreyDark),
                                  subtitle: normalText(
                                      text: "${data[index]['p_price']} Bath",
                                      color: fontGrey),
                                )),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}

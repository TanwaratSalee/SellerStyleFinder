import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
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
              return loadingIndicator();
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
                            title: orders,
                            count: "${data.length}",
                            icon: icOrders)
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
                    boldText(text: popular, color: greyDark2, size: 16.0),
                    10.heightBox,
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          if (data[index]['p_wishlist'].isEmpty) {
                            return SizedBox
                                .shrink(); // Use shrink for more semantically correct empty space
                          }
                            return ListTile(
                              onTap: () async {
                                var productSnapshot = await FirebaseFirestore.instance
                                    .collection('products')
                                    .where('p_name', isEqualTo: data[index]['p_name'])
                                    .get();

                                if (productSnapshot.docs.isNotEmpty) {
                                  var productData = productSnapshot.docs.first.data();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetails(data: productData),
                                    ),
                                  );
                                } else {
                                  // หากไม่พบข้อมูลสินค้าที่ตรงกับชื่อที่ต้องการ
                                  // อาจจะทำการแจ้งเตือนผู้ใช้หรือทำการจัดการตามต้องการ
                                  // ในกรณีนี้เราจะไม่ไปยังหน้า ProductDetails และอาจแสดงข้อความขึ้นมาแทน
                                  // เช่น Get.snackbar() หรือ Navigator.push() ไปยังหน้าที่เหมาะสม
                                }
                              },
                              leading: Image.network(
                                data[index]['p_imgs'][0],
                                width: 60,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                              title: Text(data[index]['p_name']).text.size(16).fontFamily(medium).make(),
                              subtitle: Text(
                                "${NumberFormat('#,##0').format(double.tryParse(data[index]['p_price'])?.toInt() ?? 0)} Bath"),
                            );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}

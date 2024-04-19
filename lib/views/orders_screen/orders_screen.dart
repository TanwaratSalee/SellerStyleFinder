import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/orders_controller.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/orders_screen/order_details.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the orders controller
    var controllers = Get.put(OrdersController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'), // Updated for simplicity
      ),
      body: StreamBuilder(
        stream: StoreServices.getOrders(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: List.generate(data.length, (index) {
                  var time = data[index]['order_date'].toDate();
                  return Container(
                    child: InkWell(
                      onTap: () {
                        Get.to(() => OrderDetails(data: data[index]));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Order code ${data[index]['order_code']}"),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month,
                                        color: greyDark1),
                                    const SizedBox(width: 10),
                                    Text(intl.DateFormat()
                                        .add_yMd()
                                        .format(time)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children:
                                  data[index]['orders'].map<Widget>((order) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                          "${order['qty']}x ", // Display quantity next to the image
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: regular)),
                                              5.widthBox,
                                      Image.network(
                                        order['img'],
                                        width: 55,
                                        height: 55,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              order['title'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: medium),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "${NumberFormat('#,##0').format(double.parse(order['price'].toString()))} Bath",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: greyDark1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  children: [
                                    const Text(
                                      "Total price  ",
                                    ),
                                    Text(
                                      "${NumberFormat('#,##0').format(double.parse(data[index]['total_amount'].toString()))}",
                                      // "${data[index]['total_amount']} ",
                                    ).text.fontFamily(medium).size(16).make(),
                                    const Text(
                                      "  Bath",
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  )
                      .box
                      .padding(const EdgeInsets.symmetric(vertical: 6, horizontal: 4))
                      .margin(const EdgeInsets.symmetric(vertical: 6, horizontal: 4))
                      .shadow
                      .color(whiteColor)
                      .rounded
                      .make();
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

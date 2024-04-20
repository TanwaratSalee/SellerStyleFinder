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
import 'package:seller_finalproject/views/widgets/appbar_widget.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controllers = Get.put(OrdersController());

    return Scaffold(
      appBar: AppBar(
        title: appbarWidget(Order) /* const Text('Orders') */,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: StoreServices.getOrders(currentUser!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.docs;
          data.sort(
(a, b) => b.get('order_date').compareTo(a.get('order_date')));

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: List.generate(data.length, (index) {
                  var order = data[index];
                  var time = order['order_date'].toDate();
                  return buildOrderItem(order, time);
                }),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildOrderItem(DocumentSnapshot order, DateTime time) {
    return Container(
      child: InkWell(
        onTap: () => Get.to(() => OrderDetails(data: order)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order code : ${order['order_code']}")
                      .text
                      .size(16)
                      .fontFamily(medium)
                      .make(),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: greyDark1),
                      const SizedBox(width: 10),
                      Text(intl.DateFormat().add_yMd().format(time)),
                    ],
                  ),
                ],
              ),
              ...buildProductList(order['orders'])
            ],
          ),
        ),
      )
          .box
          .margin(EdgeInsets.symmetric(vertical: 8))
          .border(color: thinGrey01)
          .rounded
          .make(),
    );
  }

  List<Widget> buildProductList(List orders) {
    return orders.map<Widget>((order) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Text("${order['qty']}x",
                style: TextStyle(fontSize: 14, fontFamily: regular)),
            SizedBox(width: 5),
            Image.network(order['img'],
                width: 55, height: 55, fit: BoxFit.cover),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order['title'],
                      style: TextStyle(fontSize: 16, fontFamily: medium),
                      overflow: TextOverflow.ellipsis),
                  Text(
                    "${NumberFormat('#,##0').format(double.parse(order['price'].toString()))} Bath",
                  ).text.size(14).fontFamily(regular).color(greyDark1).make(),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

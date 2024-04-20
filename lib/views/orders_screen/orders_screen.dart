import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/orders_controller.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/orders_screen/order_details.dart';
import 'package:seller_finalproject/views/widgets/appbar_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrdersController controller = Get.put(OrdersController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appbarWidget(orders),
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryApp,
          indicatorColor: primaryApp,
          indicatorWeight: 2.0,
          tabs: const [
            Tab(text: 'New'),
            Tab(text: 'Order'),
            Tab(text: 'Delivery'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildNew(context),
          buildOrders(context),
          buildDelivery(context),
          buildHistory(context),
        ],
      ),
    );
  }

  Widget buildNew(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: StoreServices.getOrders(currentUser!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No order yet!',
              style: TextStyle(fontSize: 18, color: greyColor),
            ),
          );
        }

        var data = snapshot.data!.docs.where((order) =>
            order['order_placed'] == true &&
            order['order_confirmed'] == false &&
            order['order_delivered'] == false &&
            order['order_on_delivery'] == false
        ).toList();

        return buildOrderList(data);
      },
    );
  }

  Widget buildOrders(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: StoreServices.getOrders(currentUser!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No order yet!',
              style: TextStyle(fontSize: 18, color: greyColor),
            ),
          );
        }

        var data = snapshot.data!.docs.where((order) =>
            order['order_placed'] == true &&
            order['order_confirmed'] == true &&
            order['order_delivered'] == false &&
            order['order_on_delivery'] == false
        ).toList();

        return buildOrderList(data);
      },
    );
  }

  Widget buildDelivery(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: StoreServices.getOrders(currentUser!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(
          child: Text(
            'No order yet!',
            style: TextStyle(fontSize: 18, color: greyColor),
          ),
        );
      }

        var data = snapshot.data!.docs.where((order) =>
            order['order_placed'] == true &&
            order['order_confirmed'] == true &&
            order['order_delivered'] == true &&
            order['order_on_delivery'] == false
        ).toList();

        return buildOrderList(data);
      },
    );
  }

  Widget buildHistory(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: StoreServices.getOrders(currentUser!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No order yet!',
              style: TextStyle(fontSize: 18, color: greyColor),
            ),
          );
        }

        var data = snapshot.data!.docs.where((order) =>
            order['order_placed'] == true &&
            order['order_confirmed'] == true &&
            order['order_delivered'] == true &&
            order['order_on_delivery'] == true
        ).toList();

        return buildOrderList(data);
      },
    );
  }

  Widget buildOrderList(List<DocumentSnapshot> data) {
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
          .margin(const EdgeInsets.symmetric(vertical: 8))
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
                style: const TextStyle(fontSize: 14, fontFamily: regular)),
            const SizedBox(width: 5),
            Image.network(order['img'],
                width: 55, height: 55, fit: BoxFit.cover),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order['title'],
                      style: const TextStyle(fontSize: 16, fontFamily: medium),
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
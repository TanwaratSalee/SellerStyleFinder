import 'package:intl/intl.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/orders_controller.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';
import 'package:seller_finalproject/views/orders_screen/components/order_place.dart';
import 'package:seller_finalproject/views/widgets/our_button.dart';
import '../../const/const.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class OrderDetails extends StatefulWidget {
  final dynamic data;
  const OrderDetails({super.key, this.data});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var controller = Get.find<OrdersController>();

  @override
  void initState() {
    super.initState();
    controller.getOrders(widget.data);
    controller.confirmed.value = widget.data['order_confirmed'];
    controller.ondelivery.value = widget.data['order_on_delivery'];
    controller.delivered.value = widget.data['order_delivered'];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          appBar: AppBar(
            title: const Text("Order Details")
                .text
                .size(24)
                .fontFamily(medium)
                .make(),
          ),
          bottomNavigationBar: Visibility(
            visible: !controller.confirmed.value,
            child: SizedBox(
              height: 60,
              width: context.screenWidth,
              child: ourButton(
                color: primaryApp,
                onPress: () {
                  controller.confirmed(true);
                  controller.changeStatus(
                      title: "order_confirmed",
                      status: true,
                      docID: widget.data.id);
                },
                title: "Confirm Order",
                textColor: thinGrey01,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Visibility(
                    visible: controller.confirmed.value,
                    child: Column(
                      children: [
                        10.heightBox,
                        const Text("Order Status"),
                        SwitchListTile(
                          activeColor: primaryApp,
                          value: true,
                          onChanged: (value) {},
                          title: const Text("Placed"),
                        ),
                        SwitchListTile(
                          activeColor: primaryApp,
                          value: controller.confirmed.value,
                          onChanged: (value) {
                            controller.confirmed.value = value;
                          },
                          title: const Text("Confirmed"),
                        ),
                        SwitchListTile(
                          activeColor: primaryApp,
                          value: controller.ondelivery.value,
                          onChanged: (value) {
                            controller.ondelivery.value = value;
                            controller.changeStatus(
                                title: "order_on_delivery",
                                status: value,
                                docID: widget.data.id);
                          },
                          title: const Text("On Delivery"),
                        ),
                        SwitchListTile(
                          activeColor: primaryApp,
                          value: controller.delivered.value,
                          onChanged: (value) {
                            controller.delivered.value = value;
                            controller.changeStatus(
                                title: "order_delivered",
                                status: value,
                                docID: widget.data.id);
                          },
                          title: const Text("Delivered"),
                        ),
                      ],
                    )
                        .box
                        .padding(const EdgeInsets.all(8.0))
                        .outerShadowMd
                        .white
                        .border(color: thinGrey01)
                        .rounded
                        .make(),
                  ),

                  10.heightBox,
                  Column(
                    children: [
                      orderPlaceDetails(
                        d1: "${widget.data['order_code']}",
                        d2: "${widget.data['shipping_method']}",
                        title1: "Order Code",
                        title2: "Shipping Method",
                      ),
                      orderPlaceDetails(
                        // d1: DateTime.now(),
                        d1: intl.DateFormat()
                            .add_yMd()
                            .format((widget.data['order_date'].toDate())),
                        d2: "${widget.data['payment_method']}",
                        title1: "Order Date",
                        title2: "Payment Method",
                      ),
                      orderPlaceDetails(
                        d1: "Unpaid",
                        d2: "Order Placed",
                        title1: "Payment Status",
                        title2: "Delivery Status",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // "Shipping Address".text.fontFamily(semibold).make(),
                                const Text("Shipping Address")
                                    .text
                                    .size(15)
                                    .fontFamily(bold)
                                    .make(),
                                "${widget.data['order_by_name']}".text.make(),
                                "${widget.data['order_by_firstname']} ${widget.data['order_by_surname']}"
                                    .text
                                    .make(),
                                // "${widget.data['order_by_email']}".text.make(),
                                "${widget.data['order_by_address']}"
                                    .text
                                    .make(),
                                "${widget.data['order_by_city']}".text.make(),
                                "${widget.data['order_by_state']}".text.make(),
                                "${widget.data['order_by_postalcode']}"
                                    .text
                                    .make(),
                                "${widget.data['order_by_phone']}".text.make(),
                              ],
                            ),
                            SizedBox(
                              width: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Total Amount",
                                  ).text.size(15).fontFamily(bold).make(),
                                  Text(
                                      "${NumberFormat('#,##0').format(double.parse(widget.data['total_amount'].toString()).toInt())} Bath")
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                      .box
                      .outerShadowMd
                      .white
                      .border(color: thinGrey01)
                      .rounded
                      .make(),
                  // const Divider(color: thinGrey0),
                  10.heightBox,
                  Column(children: [
                    10.heightBox,
                    const Text("Ordered Product")
                        .text
                        .size(20)
                        .fontFamily(medium)
                        .make(),
                    10.heightBox,
                    ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children:
                          List.generate(controller.orders.length, (index) {
                        return ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children:
                              List.generate(controller.orders.length, (index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 10),
                                Text("${controller.orders[index]['qty']}x",
                                    style: const TextStyle(
                                        fontSize: 14, fontFamily: regular)),
                                const SizedBox(width: 15),
                                Image.network(
                                  controller.orders[index]['img'],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.orders[index]['title'],
                                      style: const TextStyle(
                                          fontSize: 16, fontFamily: medium),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "${NumberFormat('#,##0').format(double.parse(controller.orders[index]['price'].toString()))} Bath",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: regular,
                                          color: greyDark1),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    width:
                                        10), // Provide spacing between text and the color box
                                // Container(
                                //   width: 30,
                                //   height: 20,
                                //   color:
                                //       Color(controller.orders[index]['color']),
                                // ),
                              ],
                            );
                          }).toList(),
                        ).box.padding(EdgeInsets.all(8)).make();
                      }).toList(),
                    ),
                    20.heightBox,
                  ])
                      .box
                      .outerShadowMd
                      .white
                      // .border(color: thinGrey01)
                      .rounded
                      .make(),
                ],
              ),
            ),
          )),
    );
  }
}

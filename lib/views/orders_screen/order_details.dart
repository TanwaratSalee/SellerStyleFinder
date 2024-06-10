import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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

  String formatPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'\D'), '');

    if (cleaned.length == 10) {
      final RegExp regExp = RegExp(r'(\d{3})(\d{3})(\d{4})');
      return cleaned.replaceAllMapped(regExp, (Match match) {
        return '(+66) ${match[1]}-${match[2]}-${match[3]}';
      });
    } else if (cleaned.length == 9) {
      final RegExp regExp = RegExp(r'(\d{2})(\d{3})(\d{4})');
      return cleaned.replaceAllMapped(regExp, (Match match) {
        return '(+66) ${match[1]}-${match[2]}-${match[3]}';
      });
    }
    return phone;
  }

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
              height: 75,
              width: context.screenWidth,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
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
                  textColor: whiteColor,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Visibility(
                    visible: controller.confirmed.value,
                    child: Column(
                      children: [
                        10.heightBox,
                        const Text("Order Status")
                            .text
                            .fontFamily(semiBold)
                            .size(20)
                            .make(),
                        ListTile(
                          title: const Text("Placed"),
                          trailing: Switch(
                            activeColor: whiteColor,
                            activeTrackColor: primaryApp,
                            inactiveThumbColor: greyDark,
                            inactiveTrackColor: whiteColor,
                            value: true,
                            onChanged: (value) {},
                          ),
                        ),
                        ListTile(
                          title: const Text("Confirmed"),
                          trailing: Switch(
                            activeColor: whiteColor,
                            activeTrackColor: primaryApp,
                            inactiveThumbColor: greyDark,
                            inactiveTrackColor: whiteColor,
                            value: controller.confirmed.value,
                            onChanged: (value) {
                              controller.confirmed.value = value;
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("On Delivery"),
                          trailing: Switch(
                            activeColor: whiteColor,
                            activeTrackColor: primaryApp,
                            inactiveThumbColor: greyDark,
                            inactiveTrackColor: whiteColor,
                            value: controller.ondelivery.value,
                            onChanged: (value) {
                              controller.ondelivery.value = value;
                              controller.changeStatus(
                                  title: "order_on_delivery",
                                  status: value,
                                  docID: widget.data.id);
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text("Delivered"),
                          trailing: Switch(
                            activeColor: whiteColor,
                            activeTrackColor: primaryApp,
                            inactiveThumbColor: greyDark,
                            inactiveTrackColor: whiteColor,
                            value: controller.delivered.value,
                            onChanged: (value) {
                              controller.delivered.value = value;
                              controller.changeStatus(
                                  title: "order_delivered",
                                  status: value,
                                  docID: widget.data.id);
                            },
                          ),
                        ),
                      ],
                    )
                        .box
                        .color(whiteColor)
                        .roundedSM
                        .border(color: greyLine)
                        .padding(const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12))
                        .make(),
                  ),
                  15.heightBox,
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Shipping Address",
                          ).text.size(20).black.fontFamily(medium).make(),
                          5.heightBox,
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined),
                              20.widthBox,
                              Text(
                                  "${widget.data['order_by_firstname']} ${widget.data['order_by_surname']},\n${widget.data['order_by_address']},\n${widget.data['order_by_city']}, ${widget.data['order_by_state']},${widget.data['order_by_postalcode']}\n${(widget.data['order_by_phone'])}"),
                            ],
                          ),
                        ],
                      )
                          .box
                          .color(whiteColor)
                          .roundedSM
                          .border(color: greyLine)
                          .padding(const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 12))
                          .make(),
                      const SizedBox(height: 15),
                      Container(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Order Code :    ')
                                        .text
                                        .size(14)
                                        .black
                                        .fontFamily(semiBold)
                                        .make(),
                                    Text(widget.data['order_code'])
                                  ],
                                ),
                                5.heightBox,
                                Row(
                                  children: [
                                    Text('Order Date :    ')
                                        .text
                                        .size(14)
                                        .black
                                        .fontFamily(semiBold)
                                        .make(),
                                    Text(intl.DateFormat().add_yMd().format(
                                        (widget.data['order_date'].toDate())))
                                  ],
                                ),
                                5.heightBox,
                                Row(
                                  children: [
                                    Text('Payment Method :    ')
                                        .text
                                        .size(14)
                                        .black
                                        .fontFamily(semiBold)
                                        .make(),
                                    Text(widget.data['shipping_method'])
                                  ],
                                ),
                              ],
                            )),
                      )
                          .box
                          .color(whiteColor)
                          .roundedSM
                          .border(color: greyLine)
                          .padding(const EdgeInsets.all(6))
                          .make(),
                    ],
                  ),
                  15.heightBox,
                  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(
                          children: [
                            Image.asset(iconsStore, width: 20),
                            10.widthBox,
                            const Text("Order List")
                                .text
                                .size(16)
                                .fontFamily(semiBold)
                                .make(),
                          ],
                        ),
                        5.heightBox,
                        Divider(
                          color: greyLine,
                        ),
                        5.heightBox,
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.orders.length,
                          itemBuilder: (context, index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${controller.orders[index]['qty']}x",
                                    style: const TextStyle(
                                        fontSize: 14, fontFamily: regular)),
                                const SizedBox(width: 5),
                                Image.network(
                                  controller.orders[index]['img'],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ).box.color(whiteOpacity).make(),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 180,
                                      child: Text(
                                        controller.orders[index]['title'],
                                        style: const TextStyle(
                                            fontSize: 14, fontFamily: medium),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      "${NumberFormat('#,##0').format(double.parse(controller.orders[index]['price'].toString()))} Bath",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: regular,
                                          color: greyColor),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        8.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total",
                            ).text.size(14).fontFamily(regular).make(),
                            5.widthBox,
                            Text("${NumberFormat('#,##0').format(double.parse(widget.data['total_amount'].toString()).toInt())}")
                                .text
                                .size(16)
                                .fontFamily(medium)
                                .make(),
                            5.widthBox,
                            const Text(
                              "Bath",
                            ).text.size(14).fontFamily(regular).make(),
                          ],
                        ).paddingOnly(left: 18),
                      ])
                      .box
                      .color(whiteColor)
                      .roundedSM
                      .padding(EdgeInsets.all(18))
                      .border(color: greyLine)
                      .make(),
                ],
              ),
            ),
          )),
    );
  }
}

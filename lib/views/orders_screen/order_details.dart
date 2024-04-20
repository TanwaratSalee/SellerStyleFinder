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
    controller.delivered.value = widget.data[ 'order_delivered'];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text("Order Details"),
          ),
          bottomNavigationBar: Visibility(
            visible: !controller.confirmed.value,
            child: SizedBox(
              height: 60,
              width: context.screenWidth,
              child: ourButton(
                  color: primaryApp, onPress: () {
                    controller.confirmed(true);
                    controller.changeStatus(title: "order_confirmed", status: true,docID: widget.data.id);
                  }, title: "Confirm Order", textColor: thinGrey01, ),
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
                        Text("Order Status"),
                        SwitchListTile(
                          activeColor: primaryApp,
                          value: true, 
                          onChanged: (value) {}, 
                          title: Text("Placed"),
                        ),
                        SwitchListTile(
                          activeColor: primaryApp,
                          value: controller.confirmed.value, 
                          onChanged: (value) {
                            controller.confirmed.value = value;
                          }, 
                          title: Text("Confirmed"),
                        ),
                        SwitchListTile(
                          activeColor: primaryApp,
                          value: controller.ondelivery.value, 
                          onChanged: (value) {
                            controller.ondelivery.value = value;
                            controller.changeStatus(title: "order_on_delivery", status: value, docID: widget.data.id);
                          }, 
                          title: Text("On Delivery"),
                        ),
                        SwitchListTile(
                          activeColor: primaryApp,
                          value: controller.delivered.value, onChanged: (value) {
                            controller.delivered.value = value;
                            controller.changeStatus(title: "order_delivered", status: value, docID: widget.data.id);
                          }, 
                          title: Text("Delivered"),
                        ),
                      ],
                    ).box.padding(const EdgeInsets.all(8.0)).outerShadowMd.white.border(color: thinGrey01).rounded.make(),
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
                        d1: intl.DateFormat().add_yMd().format((widget.data['order_date'].toDate())),
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
                                Text(
                                "Shipping Address",),
                                "${widget.data['order_by_name']}".text.make(),
                                "${widget.data['order_by_email']}".text.make(),
                                "${widget.data['order_by_address']}".text.make(),
                                "${widget.data['order_by_city']}".text.make(),
                                "${widget.data['order_by_state']}".text.make(),
                                "${widget.data['order_by_phone']}".text.make(),
                                "${widget.data['order_by_postalcode']}".text.make(),
                              ],
                            ),
                            SizedBox(
                              width: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Total Amount",),
                                  Text(
                                      "${widget.data['total_amount']} Bath", ),
                                  // "Total Amount".text.fontFamily(semibold).make(),
                                  // "${data['total_amount']}".text.color(primaryApp).fontFamily(bold).make()
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ).box.outerShadowMd.white.border(color: thinGrey01).rounded.make(),
                  // const Divider(),
                  10.heightBox,
                 Column(
                   children: [
                  10.heightBox,
                    Text("Ordered Product"),
                  10.heightBox,
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(controller.orders.length, (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          orderPlaceDetails(
                              title1: "${controller.orders[index]['title']} Bath",
                              title2: "${controller.orders[index]['price']} Bath",
                              d1: "${controller.orders[index]['qty']}x",
                              d2: "Refundable"),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              width: 30,
                              height: 20,
                              color: Color(controller.orders[index]['color']),
                            ),
                          ),
                          
                        ],
                      );
                    }).toList(),
                  ),
                  20.heightBox,
                   ] 
                 ).box.outerShadowMd.white.border(color: thinGrey01).rounded.make(),
                ],
              ),
            ),
          )),
    );
  }
}

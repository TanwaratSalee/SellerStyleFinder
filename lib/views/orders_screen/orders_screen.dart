import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/orders_controller.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/orders_screen/order_details.dart';
import 'package:seller_finalproject/views/widgets/appbar_widget.dart';
import 'package:seller_finalproject/views/widgets/text_style.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;


class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var controllers = Get.put(OrdersController()); 

    return Scaffold(
      appBar: AppBar(title: appbarWidget(orders),
      bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                child: Row(
                  children: [
                    const Text('All '),
                    Text('(10)'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Text('Unpaid '),
                    Text('(5)'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Text('In Transit '),
                    Text('(7)'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Text('Awaiting Shipment '),
                    Text('(3)'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Text('Delivered '),
                    Text('(15)'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    const Text('Completed '),
                    Text('(20)'),
                  ],
                ),
              ),
            ],
          ),
        
      ) 
      ,
      body: StreamBuilder(
        stream: StoreServices.getOrders(currentUser!.uid), 
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return loadingIndicator();
          } else {
            var data = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(data.length,
                      (index) {
                        var time = data[index]['order_date'].toDate();

                        return ListTile(
                            onTap: () {
                              Get.to(() => OrderDetails(data: data[index]));
                            },
                            tileColor: thinGrey01,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)
                            ),
                            title: boldText(text:"${data[index]['order_code']}", color: greyDark2),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_month, color: greyDark2),
                                    10.widthBox,
                                    boldText(text: intl.DateFormat().add_yMd().format(time),color: greyColor),
                                  ],
                                ),
                                3.heightBox,
                                Row(
                                  children: [
                                    const Icon(Icons.payment, color: greyDark2),
                                    10.widthBox,
                                    boldText(text: unpaid,color: redColor),
                                  ],
                                )
                              ],
                            ),
                            // ignore: unnecessary_string_escapes
                            trailing: boldText(text: "${data[index]['total_amount']} Bath", color: blackColor, size: 16.0),
                          ).box.margin(const EdgeInsets.only(bottom: 5)).make();
                      }
                        ),
                ),
              ),
            );
          }
        })
    );
  }
}

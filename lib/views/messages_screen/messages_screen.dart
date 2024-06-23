import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/messages_screen/chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  final String userName;

  const MessagesScreen({Key? key, required this.userName}) : super(key: key);

  Future<Map<String, String>> getVendorDetails(String vendorId) async {
    if (vendorId.isEmpty) {
      debugPrint('Error: vendorId is empty.');
      return {'name': 'Unknown Vendor', 'imageUrl': ''};
    }

    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(vendorId)
          .get();
      if (userSnapshot.exists) {
        var vendorData = userSnapshot.data() as Map<String, dynamic>?;
        return {
          'name': vendorData?['name'] ?? 'Unknown Vendor',
          'imageUrl': vendorData?['imageUrl'] ?? ''
        };
      } else {
        return {'name': 'Unknown Vendor', 'imageUrl': ''};
      }
    } catch (e) {
      debugPrint('Error getting vendor details: $e');
      return {'name': 'Unknown Vendor', 'imageUrl': ''};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: StoreServices.getMessages(currentUser!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator(circleColor: primaryApp);
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No messages available'));
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var t = data[index]['created_on'] == null
                      ? DateTime.now()
                      : data[index]['created_on'].toDate();
                  var time = intl.DateFormat("h:mma").format(t);
                  var chatDocId = data[index].id;
                  var friendId = data[index]['user_id'];
                  var sellerId = data[index]['vendor_id'];

                  return FutureBuilder<Map<String, String>>(
                    future: getVendorDetails(friendId),
                    builder: (context, vendorSnapshot) {
                      if (vendorSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (vendorSnapshot.hasError) {
                        return Text('Error: ${vendorSnapshot.error}');
                      } else if (!vendorSnapshot.hasData ||
                          vendorSnapshot.data!['name']!.isEmpty) {
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 27,
                            backgroundColor: primaryApp,
                            child: Icon(
                              Icons.person,
                              color: whiteColor,
                              size: 27,
                            ),
                          ).box.border(color: greyLine).roundedFull.make(),
                          title: Text('Unknown Vendor'),
                          subtitle: Text(
                            "${data[index]['last_msg']}",
                            style: TextStyle(color: greyDark),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                              .text
                              .fontFamily(regular)
                              .size(14)
                              .color(greyColor)
                              .make(),
                          trailing: Text(time),
                        );
                      } else {
                        var userName =
                            vendorSnapshot.data!['name'] ?? 'Unknown Vendor';
                        var userImageUrl =
                            vendorSnapshot.data!['imageUrl'] ?? '';

                        return ListTile(
                          onTap: () {
                            Get.to(() => ChatScreen(
                                  userName: userName,
                                  userImageUrl: userImageUrl,
                                  chatDocId: chatDocId,
                                  friendId: friendId,
                                  sellerId: sellerId,
                                ));
                          },
                          leading: CircleAvatar(
                            radius: 27,
                            backgroundColor: primaryApp,
                            backgroundImage: userImageUrl.isNotEmpty
                                ? NetworkImage(userImageUrl)
                                : null,
                            child: userImageUrl.isEmpty
                                ? Icon(
                                    Icons.person,
                                    color: whiteColor,
                                    size: 27,
                                  )
                                : null,
                          ).box.border(color: greyLine).roundedFull.make(),
                          title: Text(userName),
                          subtitle: SizedBox(
                            width: 250,
                            height: 20,
                            child: Text(
                              "${data[index]['last_msg']}",
                              style: TextStyle(color: greyDark),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                                .text
                                .fontFamily(regular)
                                .size(14)
                                .color(greyColor)
                                .make(),
                          ),
                          trailing: Text(time),
                        );
                      }
                    },
                  );
                },
              ),
              // Divider(color: greyLine,)
            );
          }
        },
      ),
    );
  }
}

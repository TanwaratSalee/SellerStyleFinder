import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/services/store_services.dart';
import 'package:seller_finalproject/views/messages_screen/chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  final String vendorName;

  const MessagesScreen({Key? key, required this.vendorName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: StoreServices.getMessages(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  var friendId = data[index]['toId'];
                  var sellerId = data[index]['fromId'];

                  return ListTile(
                    onTap: () {
                      Get.to(() => ChatScreen(
                        vendorName: vendorName,
                        chatDocId: chatDocId,
                        friendId: friendId,
                        sellerId: sellerId,
                      ));
                    },
                    leading: const CircleAvatar(
                      backgroundColor: primaryApp,
                      child: Icon(
                        Icons.person,
                        color: whiteColor,
                      ),
                    ),
                    title: Text("${data[index]['sender_name']}"),
                    subtitle: Text("${data[index]['last_msg']}"),
                    trailing: Text(time),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

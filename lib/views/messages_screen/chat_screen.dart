import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/chat_controller.dart';
import 'package:seller_finalproject/views/messages_screen/components/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  final String vendorName;
  final String chatDocId; // Add the chatDocId parameter
  final String friendId; // Add the friendId parameter
  final String sellerId; // Add the sellerId parameter

  const ChatScreen({
    Key? key,
    required this.vendorName,
    required this.chatDocId,
    required this.friendId,
    required this.sellerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());

    return Scaffold(
      appBar: AppBar(
        title: Text(vendorName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatDocId)
                  .collection('messages')
                  .orderBy('created_on', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages with $vendorName'));
                } else {
                  var messages = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      return chatBubble(message);
                    },
                  );
                }
              },
            ),
          ),
          10.heightBox,
          SizedBox(
            height: 56,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.msgController,
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: "Enter message",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryApp)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryApp)),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.sendMsg(
                      controller.msgController.text,
                      chatDocId,
                      friendId,
                      sellerId,
                      vendorName,
                    );
                    controller.msgController.clear();
                  },
                  icon: const Icon(Icons.send, color: primaryApp),
                ),
              ],
            ),
          ),
          10.heightBox,
        ]),
      ),
    );
  }
}

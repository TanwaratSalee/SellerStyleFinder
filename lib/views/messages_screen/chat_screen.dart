import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/chat_controller.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/views/messages_screen/components/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  final String userName;
  final String chatDocId;
  final String friendId;
  final String sellerId;
  final String userImageUrl;

  const ChatScreen({
    Key? key,
    required this.userName,
    required this.chatDocId,
    required this.friendId,
    required this.sellerId,
    required this.userImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());
    FocusNode focusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: primaryApp,
              backgroundImage:
                  userImageUrl.isNotEmpty ? NetworkImage(userImageUrl) : null,
            ),
            SizedBox(width: 15),
            Text(
              userName,
              style: TextStyle(
                fontSize: 18,
                fontFamily: medium,
                color: blackColor,
              ),
            ),
          ],
        ),
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
                  return Center(child: Text('No messages with $userName'));
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
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: greyLine),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: greyColor),
                      ),
                      hintText: "Type a message...",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
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

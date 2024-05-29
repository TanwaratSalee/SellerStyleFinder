import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/firebase_consts.dart';
import 'package:seller_finalproject/services/store_services.dart';

class ChatsController extends GetxController {
  var chats = firestore.collection(chatsCollection);
  var msgController = TextEditingController();

  Future<void> sendMsg(String msg, String chatDocId, String friendId,
      String sellerId, String vendorName) async {
    if (msg.trim().isNotEmpty) {
      await chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': friendId,
        'fromId': sellerId,
        'vendor_name': vendorName,
      });

      await chats
          .doc(chatDocId)
          .collection('messages')
          .doc()
          .set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': sellerId,
        'vendor_name': vendorName,
      });
    }
  }
}

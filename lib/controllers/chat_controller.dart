import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/firebase_consts.dart';

class ChatsController extends GetxController {
  var chats = firestore.collection(chatsCollection);
  var msgController = TextEditingController();

  Future<void> sendMsg(
      String msg, String chatDocId, String friendId, String vendorName) async {
    String sellerId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (msg.trim().isNotEmpty && sellerId.isNotEmpty) {
      await chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
      });

      await chats.doc(chatDocId).collection('messages').doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': sellerId,
      });
    }
  }
}

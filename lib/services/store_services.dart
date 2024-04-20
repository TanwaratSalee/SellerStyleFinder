import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seller_finalproject/const/firebase_consts.dart';

class StoreServices {
  static getProfile(uid) {
    return firestore.collection(vendorsCollection).where('id', isEqualTo: uid).get();
  }

  static getMessages(uid) {
    return firestore.collection(chatsCollection).where('toId', isEqualTo: uid).snapshots();
  }

  static getOrders(uid) {
    return firestore.collection(ordersCollection).where('vendors', arrayContains: uid).snapshots();
  }

  static getProducts(uid) {
    return firestore.collection(productsCollection).where('vendor_id', isEqualTo: uid).snapshots();
  }

  static Stream<QuerySnapshot> getUserOrders(String userId) {
    // Renamed for clarity: This fetches orders based on 'user_id'
    return firestore.collection(ordersCollection)
        .where('user_id', isEqualTo: userId)
        .orderBy('order_date', descending: true)  
        .snapshots();
  }
}


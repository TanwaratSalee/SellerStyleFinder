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
    return firestore.collection(ordersCollection).where('vendors', isEqualTo: userId).orderBy('order_date', descending: true)  .snapshots();
  }

  static Stream<QuerySnapshot> getOrdersByStatus(String userId, String status) {
    return FirebaseFirestore.instance.collection(ordersCollection).where('user_id', isEqualTo: userId).where('status', isEqualTo: status).snapshots();
  }


}


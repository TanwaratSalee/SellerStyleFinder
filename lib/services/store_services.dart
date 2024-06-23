import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seller_finalproject/const/firebase_consts.dart';

class StoreServices {
  static Future<QuerySnapshot> getProfile(String uid) {
    return firestore
        .collection(vendorsCollection)
        .where('vendor_id', isEqualTo: uid)
        .get();
  }

  static Stream<QuerySnapshot> getMessages(String uid) {
    return firestore
        .collection(chatsCollection)
        .where('toId', isEqualTo: uid)
        .snapshots();
  }

  static Stream<QuerySnapshot> getOrders(String uid) {
    return firestore
        .collection(ordersCollection)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }

  /* static Stream<QuerySnapshot> getOrders(String uid) {
    return FirebaseFirestore.instance.collection('orders').snapshots();
  } */

  static Stream<QuerySnapshot> getProducts(String uid) {
    return firestore
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }

  // static Stream<QuerySnapshot> getUserOrders(String userId) {
  //   return firestore.collection(ordersCollection).where('vendors', isEqualTo: userId).orderBy('order_date', descending: true)  .snapshots();
  // }

  // static Stream<QuerySnapshot> getOrdersByStatus(String userId, String status) {
  //   return FirebaseFirestore.instance.collection(ordersCollection).where('user_id', isEqualTo: userId).where('status', isEqualTo: status).snapshots();
  // }
}

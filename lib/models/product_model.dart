import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String vendorId;
  final String part;
  final String price;
  final String mixmatch;
  final List<String> imageUrls;

  Product({
    required this.id,
    required this.name,
    required this.vendorId,
    required this.part,
    required this.price,
    required this.mixmatch,
    required this.imageUrls,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Product data is null');
    }

    return Product(
      id: doc.id,
      name: data['p_name'] ?? '',
      vendorId: data['vendor_id'] ?? '',
      part: data['p_part'] ?? '',
      price: data['p_price'] ?? '',
      mixmatch: data['p_mixmatch'] ?? '', 
      imageUrls: List<String>.from(data['p_imgs'] ?? []),
    );
  }
}

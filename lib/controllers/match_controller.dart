import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/models/collection_model.dart';

class MatchController extends GetxController {
  var isloading = false.obs;

  //text field controllers

  var pnameController = TextEditingController();
  var pabproductController = TextEditingController();
  var pdescController = TextEditingController();
  var psizeController = TextEditingController();
  var ppriceController = TextEditingController();
  var pquantityController = TextEditingController();
  var explainController = TextEditingController();

  var collectionsList = <String>[].obs;
  var subcollectionList = <String>[].obs;
  List<Collection> collection = [];
  var pImagesLinks = [];
  var pImagesList = RxList<dynamic>(List.filled(9, null, growable: true));

  List<String> imagesToDelete = [];
  var collectionsvalue = ''.obs;
  var subcollectionvalue = ''.obs;
  var selectedColorIndex = 0.obs;
  var selectedCollections = <String>[].obs;

  List<String> sizesList = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final selectedSizes = <String>[].obs;
  List<String> genderList = ['all', 'male', 'female'];
  RxString selectedGender = ''.obs;
  List<String> mixandmatchList = ['top', 'lower', 'not specified'];
  RxString selectedMixandmatch = ''.obs;
  List<String> collectionList = ['summer', 'winter', 'autumn', 'dinner', 'everydaylook'];
  RxString selectedCollection = ''.obs;

  final selectedColorIndexes = <int>[].obs;
  final List<Map<String, dynamic>> allColors = [
    {'name': 'Black', 'color': Colors.black},
    {'name': 'Grey', 'color': greyColor},
    {'name': 'White', 'color': whiteColor},
    {'name': 'Purple', 'color': Colors.purple},
    {'name': 'Deep Purple', 'color': Colors.deepPurple},
    {'name': 'Blue', 'color': Colors.lightBlue},
    {'name': 'Blue', 'color': const Color.fromARGB(255, 36, 135, 216)},
    {'name': 'Blue Grey', 'color': const Color.fromARGB(255, 96, 139, 115)},
    {'name': 'Green', 'color': const Color.fromARGB(255, 17, 82, 50)},
    {'name': 'Green', 'color': Colors.green},
    {'name': 'Green Accent', 'color': Colors.greenAccent},
    {'name': 'Yellow', 'color': Colors.yellow},
    {'name': 'Orange', 'color': Colors.orange},
    {'name': 'Red', 'color': redColor},
    {'name': 'Red Accent', 'color': const Color.fromARGB(255, 237, 101, 146)},
  ];

  void resetController() {
    selectedGender.value = '';
    selectedCollection.value = '';
    selectedColorIndexes.clear();
    selectedCollections.clear();
  }

  void toggleCollection(String collection) {
    if (selectedCollections.contains(collection)) {
      selectedCollections.remove(collection);
    } else {
      selectedCollections.add(collection);
    }
  }
  bool isCollectionSelected(String collection) {
    return selectedCollections.contains(collection);
  }

  Product? selectedTopProduct;
  Product? selectedLowerProduct;

void onTopProductSelected(Product product) {
  selectedTopProduct = product;
  print("Selected top product: ${selectedTopProduct?.name}");
  Get.dialog(AlertDialog(
    title: Text(product.name),
    content: Text('Top Product Selected'),
));
}


void onLowerProductSelected(Product product) {
  selectedLowerProduct = product;
  print("Selected lower product: ${selectedLowerProduct?.name}");
  Get.dialog(AlertDialog(
    title: Text(product.name),
    content: Text('Lower Product Selected'),
));
}

String? getTopProductDocumentId() {
  return selectedTopProduct != null ? selectedTopProduct!.id : null;
}

String? getLowerProductDocumentId() {
  return selectedLowerProduct != null ? selectedLowerProduct!.id : null;
}

Future<Rxn<List<Product>>> fetchTopProductsByVendor(String vendorId) async {
  return Rxn<List<Product>>(await _fetchProductsByVendorAndPart(vendorId, 'top'));
}

Future<Rxn<List<Product>>> fetchLowerProductsByVendor(String vendorId) async {
  return Rxn<List<Product>>(await _fetchProductsByVendorAndPart(vendorId, 'lower'));
}

  Future<List<Product>> _fetchProductsByVendorAndPart(String vendorId, String part) async {
    List<Product> products = [];
    try {
      var productsQuery =
          FirebaseFirestore.instance.collection('products').where('vendor_id', isEqualTo: vendorId).where('p_part', isEqualTo: part);
      var querySnapshot = await productsQuery.get();
      for (var doc in querySnapshot.docs) {
        products.add(Product.fromFirestore(doc));
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
    return products;
  }

Future<void> onSaveButtonPressed(BuildContext context) async {
  if (selectedTopProduct != null && selectedLowerProduct != null) {
    try {
      // สร้างสตริงสุ่มเพื่อใช้เป็นค่า 'p_mixmatch' สำหรับทั้งสองสินค้า
      String mixMatchValue = generateRandomString(10);
      
      // ดึง document id ของสินค้าที่ถูกเลือก
      String? topProductDocumentId = getTopProductDocumentId();
      String? lowerProductDocumentId = getLowerProductDocumentId();

      // อัปเดตข้อมูลสินค้าใน Firestore
      if (topProductDocumentId != null) {
        await updateProductMatch(context, topProductDocumentId, mixMatchValue);
      }
      if (lowerProductDocumentId != null) {
        await updateProductMatch(context, lowerProductDocumentId, mixMatchValue);
      }

      VxToast.show(context, msg: "Products updated successfully.");
    } catch (e) {
      VxToast.show(context, msg: "Error updating products. Please try again later.");
      print("Error updating products: $e");
    }
  } else {
    VxToast.show(context, msg: "Please select both top and lower products.");
  }
}

bool isDataIncomplete(MatchController controller) {
  if (controller.selectedTopProduct == null ||
      controller.selectedLowerProduct == null ||
      controller.selectedGender.isEmpty ||
      controller.selectedColorIndexes.isEmpty ||
      controller.selectedCollection.isEmpty ||
      controller.psizeController.text.isEmpty) {
    Get.snackbar(
      'Incomplete Data',
      'Please fill in all required fields',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return true;
  }
  return false;
}


Future<void> updateProductMatch(BuildContext context, String documentId, String mixMatchValue) async {
  try {
    print('Document ID before update: $documentId'); // แสดงค่า documentId ก่อนการอัปเดต
    final productDoc = FirebaseFirestore.instance.collection(productsCollection).doc(documentId);

    if (documentId.isNotEmpty) {
      await productDoc.update({
        'p_mixmatch': mixMatchValue,
        'p_mixmatch_colors': selectedColorIndexes.map((index) => allColors[index]['name']).toList(),
        'p_mixmatch_sex': selectedGender.value,
        'p_mixmatch_desc': psizeController.text,
        'p_mixmatch_collection': selectedCollections.toList(),
      });

      VxToast.show(context, msg: "Product updated successfully.");
    } else {
      // หาก documentId เป็นค่าว่างเปล่าหรือ null จะไม่ดำเนินการอัปเดตและแสดงข้อความข้อผิดพลาด
      VxToast.show(context, msg: "Error updating product: Document ID is empty.");
    }
  } catch (e) {
    // แสดงข้อความเมื่อเกิดข้อผิดพลาดในการอัปเดต
    VxToast.show(context, msg: "Error updating product. Please try again later.");
    print("Error updating product: $e");
  }
}



String generateRandomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ),
  );
}


  MatchProducts(text) {}
}

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

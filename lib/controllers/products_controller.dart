import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/home_controller.dart';
import 'package:seller_finalproject/models/collection_model.dart';
import 'package:path/path.dart';

class ProductsController extends GetxController {
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

  List<String> sizesList = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final selectedSizes = <String>[].obs;
  List<String> genderList = [ 'all','male', 'female'];
  RxString selectedGender = ''.obs;

  List<String> mixandmatchList = [ 'top','lower', 'not specified'];
  RxString selectedMixandmatch = ''.obs;



  RxString selectedSkinColor = ''.obs;
  List<Map<String, dynamic>> skinColorList = [
  {'name': 'Light', 'color': Color(0xFFFFDBAC)},   
  {'name': 'Medium', 'color': Color(0xFFE5A073)},  
  {'name': 'Medium', 'color': Color(0xFFCD8C5C)},  
  {'name': 'Dark', 'color': Color(0xFF5C3836)},    
];


  final selectedColorIndexes = <int>[].obs;
   final List<Map<String, dynamic>> allColors = [
    {'name': 'Black', 'color': Colors.black},
    {'name': 'Grey', 'color': Colors.grey},
    {'name': 'White', 'color': Colors.white},
    {'name': 'Purple', 'color': Colors.purple},
    {'name': 'Deep Purple', 'color': Colors.deepPurple},
    {'name': 'Blue', 'color': Colors.lightBlue},
    {'name': 'Blue', 'color': Color.fromARGB(255, 36, 135, 216)},
    {'name': 'Blue Grey', 'color': const Color.fromARGB(255, 96, 139, 115)},
    {'name': 'Green', 'color': Color.fromARGB(255, 17, 82, 50)},
    {'name': 'Green', 'color': Colors.green},
    {'name': 'Green Accent', 'color': Colors.greenAccent},
    {'name': 'Yellow', 'color': Colors.yellow},
    {'name': 'Orange', 'color': Colors.orange},
    {'name': 'Red', 'color': Colors.red},
    {'name': 'Red Accent', 'color': Color.fromARGB(255, 237, 101, 146)},
  ];

  Rxn<Product> selectedTopProduct = Rxn<Product>();
  Rxn<Product> selectedLowerProduct = Rxn<Product>(); 

  void setSelectedProduct(Product product, String part) {
    if (part == 'top') {
      selectedTopProduct.value = product;
    } else if (part == 'lower') {
      selectedLowerProduct.value = product;
    }
    update(); // Triggers UI update
  }

getCollection() async {
    var data = await rootBundle.loadString("lib/services/collection_model.json");
    var cat = collectionModelFromJson(data);
    collection = cat.collections;
    populateCollectionList();
}

  populateCollectionList() {
    collectionsList.clear();

    for (var item in collection) {
      collectionsList.add(item.name);
    }
  }

  populateSubcollection(cat) {
    subcollectionList.clear();

    var data = collection.where((element) => element.name == cat).toList();

    for (var i = 0; i < data.first.subcollection.length; i++) {
      subcollectionList.add(data.first.subcollection[i]);
    }
  }

  pickImage(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (img == null) {
        return;
      } else {
        pImagesList[index] = File(img.path);
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

uploadImages() async {
  pImagesLinks.clear();
  for (var item in pImagesList) {
    if (item != null && item is File) {
      var filename = basename(item.path);
      var destination = 'images/vendors/${currentUser!.uid}/$filename';
      Reference ref = FirebaseStorage.instance.ref().child(destination);
      await ref.putFile(item);
      var n = await ref.getDownloadURL();
      pImagesLinks.add(n);
    } else if (item is String) {
      pImagesLinks.add(item);
    }
  }
}


void initializeImages(List<String> imageUrls) {
    // Clear existing list and add fresh from imageUrls ensuring it's growable
    pImagesList.clear();
    for (int i = 0; i < imageUrls.length; i++) {
        pImagesList.add(imageUrls[i]);
    }
    // Ensure there are always 9 slots in the list
    while (pImagesList.length < 9) {
        pImagesList.add(null);
    }
}


void setupProductData(Map<String, dynamic> productData) {
    pnameController.text = productData['p_name'] ?? '';
    pabproductController.text = productData['p_aboutProduct'] ?? '';
    pdescController.text = productData['p_desc'] ?? '';
    psizeController.text = productData['p_size'] ?? '';
    ppriceController.text = productData['p_price'] ?? '';
    pquantityController.text = productData['p_quantity'] ?? '';
    selectedGender.value = productData['p_sex'] ?? '';
    selectedMixandmatch.value = productData['p_part'] ?? '';
    collectionsvalue.value = productData['collection'] ?? '';
    if (collectionsvalue.value.isNotEmpty) {
        populateSubcollection(collectionsvalue.value);
    }

    if (productData['p_productsize'] != null) {
      selectedSizes.assignAll((productData['p_productsize'] ?? '' as List).cast<String>());
    } else {
      selectedSizes.clear();
    }

  if (productData['p_imgs'] != null) {
    initializeImages(List<String>.from(productData['p_imgs']));
  }
}

void removeImage(int index) {
  if (index >= 0 && index < pImagesList.length) {
    if (pImagesList[index] is String) { // If it's a URL, add to the delete list
      imagesToDelete.add(pImagesList[index] as String);
    }
    pImagesList.removeAt(index); // Directly remove the item at the index
    pImagesList.add(null); // Optional: Maintain list size by adding null
  }
}


  Future<void> uploadProduct(BuildContext context) async {
  try {
    isloading(true);
    // Make sure images are uploaded first if they aren't already
    if (pImagesLinks.isEmpty) {
      await uploadImages();
    }
    var store = firestore.collection(productsCollection).doc();
    await store.set({
      'is_featured': false,
      'p_collection': collectionsvalue.value,
      'p_subcollection': subcollectionvalue.value,
      'p_sex': selectedGender.value,
      'p_productsize':selectedSizes,
      'p_part':selectedMixandmatch.value,
      'p_colors': selectedColorIndexes.map((index) => allColors[index]['color'].value).toList(),
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
      'p_wishlist': FieldValue.arrayUnion([]),
      'p_desc': pdescController.text,
      'p_name': pnameController.text,
      'p_aboutProduct': pabproductController.text,
      'p_size': psizeController.text,
      'p_price': ppriceController.text,
      'p_quantity': pquantityController.text,
      'p_seller': Get.find<HomeController>().username,
      'p_rating': "5.0",
      'vendor_id': currentUser!.uid,
      'featured_id': '',
      'p_mixmatch': ''
    });
    isloading(false);
    VxToast.show(context, msg: "Product successfully uploaded.");
  } catch (e) {
    isloading(false);
    VxToast.show(context, msg: "Failed to upload product: $e");
    print(e.toString());  // For debugging purposes
  }
}

Future<void> updateProduct(BuildContext context, String documentId) async {
  try {
    final productDoc = FirebaseFirestore.instance.collection(productsCollection).doc(documentId);
    // อัปเดตข้อมูลเดิม
    await productDoc.update({
      'p_collection': collectionsvalue.value,
      'p_subcollection': subcollectionvalue.value,
      'p_sex': selectedGender.value,
      'p_productsize': selectedSizes,
      'p_part': selectedMixandmatch.value,
      'p_colors': selectedColorIndexes.map((index) => allColors[index]['color'].value).toList(),
      'p_desc': pdescController.text,
      'p_name': pnameController.text,
      'p_aboutProduct': pabproductController.text,
      'p_size': psizeController.text,
      'p_price': ppriceController.text,
      'p_quantity': pquantityController.text,
      'p_seller': Get.find<HomeController>().username,
      'vendor_id': currentUser!.uid,
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
    });

    // Removing images marked for deletion
    if (imagesToDelete.isNotEmpty) {
      await productDoc.update({
        'p_imgs': FieldValue.arrayRemove(imagesToDelete),
      });
      imagesToDelete.clear(); // Clear the list after updating
    }

    VxToast.show(context, msg: "Product updated successfully.");
  } catch (e) {
    print("Error updating product: $e");
    VxToast.show(context, msg: "Error updating product. Please try again later.");
  }
}


  addFeatured(docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'featured_id': currentUser!.uid,
      'is_featured': true,
    }, SetOptions(merge: true));
  }

  removeFeatured(docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'featured_id': '',
      'is_featured': false,
    }, SetOptions(merge: true));
  }

  removeProduct(docId) async {
    await firestore.collection(productsCollection).doc(docId).delete();
  }

  bool isDataComplete() {
  return pnameController.text.isNotEmpty &&
      pabproductController.text.isNotEmpty &&
      pdescController.text.isNotEmpty &&
      psizeController.text.isNotEmpty &&
      ppriceController.text.isNotEmpty &&
      pquantityController.text.isNotEmpty &&
      collectionsvalue.isNotEmpty &&
      subcollectionvalue.isNotEmpty &&
      selectedGender.isNotEmpty &&
      selectedSizes.isNotEmpty &&
      selectedColorIndexes.isNotEmpty;
}

void resetForm() {
    pnameController.clear();
    pabproductController.clear();
    pdescController.clear();
    psizeController.clear();
    ppriceController.clear();
    pquantityController.clear();
    selectedColorIndexes.clear();
    collectionsvalue.value = '';
    subcollectionvalue.value = '';
    pImagesLinks.clear();
    selectedGender.value = '';
    selectedSizes.clear();
    imagesToDelete.clear();
    pImagesList.clear();
    selectedMixandmatch.value = '';
    while (pImagesList.length < 9) {
        pImagesList.add(null);
    }
}




  MatchProducts(text) {}
}


class Product {
  final String id;
  final String name;
  final String vendorId;
  final String part;
  final String price;
  final String imageUrl; // Add this if your products have images.

  Product({required this.id, required this.name, required this.vendorId, required this.part, required this.price, required this.imageUrl});

  factory Product.fromFirestore(Map<String, dynamic> doc) {
    return Product(
      id: doc['id'] ?? '',
      name: doc['p_name'] ?? '',
      vendorId: doc['vendor_id'] ?? '',
      part: doc['p_part'] ?? '',
      price: doc['p_price'] ?? '',
      imageUrl: doc['p_imgs'][0] ?? '', // Assume there's an image_url field in your Firestore documents.
    );
  }
}
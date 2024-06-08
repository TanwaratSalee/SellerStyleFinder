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
  var productId = ''.obs;

  //text field controllers
  var pnameController = TextEditingController();
  var pabproductController = TextEditingController();
  var pdescController = TextEditingController();
  var psizeController = TextEditingController();
  var ppriceController = TextEditingController();
  var pquantityController = TextEditingController();
  var explainController = TextEditingController();

  var collectionsList = <String>[].obs;
  List<Collection> collection = [];
  var pImagesLinks = [];
  var pImagesList = RxList<dynamic>(List.filled(9, null, growable: true));
  
  List<String> imagesToDelete = []; 
  var collectionsvalue = ''.obs;
  var selectedColorIndex = 0.obs;
  var selectedCollections = <String>[].obs;

  List<String> sizesList = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final selectedSizes = <String>[].obs;
  List<String> genderList = [ 'all','male', 'female'];
  RxString selectedGender = ''.obs;
  List<String> mixandmatchList = [ 'top','lower', 'not specified'];
  RxString selectedMixandmatch = ''.obs;
  List<String> collectionList = [ 'summer','winter','autumn','dinner','everydaylook'];
  final selectedCollection = <String>[].obs;
  List<String> subcollectionList = [ 'dresses','outerwear & Costs','blazers','suits','blouses & Tops','knitwear','t-shirts','skirts','pants','denim','activewear'];
  RxString selectedSubcollection = ''.obs;

  RxString selectedSkinColor = ''.obs;
  List<Map<String, dynamic>> skinColorList = [
    {'name': 'Light', 'color': const Color(0xFFFFDBAC)},   
    {'name': 'Medium', 'color': const Color(0xFFE5A073)},  
    {'name': 'Medium', 'color': const Color(0xFFCD8C5C)},  
    {'name': 'Dark', 'color': const Color(0xFF5C3836)},    
  ];

  final selectedColorIndexes = <int>[].obs;
  final List<Map<String, dynamic>> allColors = [
    {'name': 'Black', 'color': Colors.black},
    {'name': 'Grey', 'color': Colors.grey},
    {'name': 'White', 'color': Colors.white},
    {'name': 'Purple', 'color': const Color.fromRGBO(98, 28, 141, 1)},
    {'name': 'Deep Purple', 'color': const Color.fromRGBO(202, 147, 235, 1)},
    {'name': 'Blue', 'color': Color.fromRGBO(32, 47, 179, 1)},
    {'name': 'Blue', 'color': const Color.fromRGBO(48, 176, 232, 1)},
    {'name': 'Blue Grey', 'color': const Color.fromRGBO(83, 205, 191, 1)},
    {'name': 'Green', 'color': const Color.fromRGBO(23, 119, 15, 1)},
    {'name': 'Green', 'color': Color.fromRGBO(98, 207, 47, 1)},
    {'name': 'Yellow', 'color': Colors.yellow},
    {'name': 'Orange', 'color': Colors.orange},
    {'name': 'Pink', 'color': Colors.pinkAccent},
    {'name': 'Red', 'color': Colors.red},
    {'name': 'Brown', 'color': Color.fromARGB(255, 121, 58, 31)},
  ];

  Rxn<Product> selectedTopProduct = Rxn<Product>();
  Rxn<Product> selectedLowerProduct = Rxn<Product>(); 

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

  RxList<String> selectedTopProductImages = RxList<String>();
  RxList<String> selectedLowerProductImages = RxList<String>();

  void updateProductImages(List<String> images, String part) {
    if (part == 'top') {
      selectedTopProductImages.assignAll(images);
    } else if (part == 'lower') {
      selectedLowerProductImages.assignAll(images);
    }
  }

  List<String> getProductImages(String part) {
    if (part == 'top') {
      return selectedTopProductImages;
    } else if (part == 'lower') {
      return selectedLowerProductImages;
    }
    return [];
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

  void toggleColorSelection(int index) {
    if (selectedColorIndexes.contains(index)) {
      selectedColorIndexes.remove(index);
    } else {
      selectedColorIndexes.add(index);
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
    selectedSubcollection.value = productData['p_subcollection'] ?? '';

    List<dynamic> colorMaps = productData['p_colors'] ?? [];
    selectedColorIndexes.clear(); // Clear existing selections
    for (var colorMap in colorMaps) {
      if (colorMap is Map && colorMap.containsKey('number')) {
        int colorNumber = colorMap['number'];
        int colorIndex = allColors.indexWhere((color) => color['number'] == colorNumber);
        if (colorIndex != -1) {
          selectedColorIndexes.add(colorIndex);
        }
      }
    }

    if (productData['p_collection'] != null) {
      selectedCollection.assignAll(List<String>.from(productData['p_collection']));
    } else {
      selectedCollection.clear();
    }

    if (productData['p_productsize'] != null) {
      selectedSizes.assignAll(List<String>.from(productData['p_productsize']));
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
      productId.value = store.id;
      await store.set({
        //Default
        'p_id': productId.value,
        'is_featured': false,
        'p_collection': selectedCollection,
        'p_subcollection': selectedSubcollection.value,
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
        //Mixmatch
        'p_mixmatch': '',
        'p_mixmatch_colors' : '',
        'p_mixmatch_sex' : '',
        'p_mixmatch_desc' : '',
        'p_mixmatch_collection' : FieldValue.arrayUnion([]),
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
      await productDoc.update({
        'p_collection': selectedCollection,
        'p_subcollection': selectedSubcollection.value,
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

      if (imagesToDelete.isNotEmpty) {
        await productDoc.update({
          'p_imgs': FieldValue.arrayRemove(imagesToDelete),
        });
        imagesToDelete.clear();
      }

      VxToast.show(context, msg: "Product updated successfully.");
    } catch (e) {
      print("Error updating product: $e");
      VxToast.show(context, msg: "Error updating product. Please try again later.");
    }
  }

  Future<void> updateProductMatch(BuildContext context, String documentId) async {
    try {
      final productDoc = FirebaseFirestore.instance.collection(productsCollection).doc(documentId);

      await productDoc.update({
        'p_mixmatch': '',
        'p_mixmatch_colors': selectedColorIndexes.map((index) => allColors[index]['name']).toList(),
        'p_mixmatch_sex': selectedGender.value,
        'p_mixmatch_desc' : psizeController.text,
        'p_mixmatch_collection': selectedCollections.toList(),
      });
      VxToast.show(context, msg: "Product updated successfully.");
    } catch (e) {
      print("Error updating product: $e");
      VxToast.show(context, msg: "Error updating product. Please try again later.");
      print(e.toString());
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

  void resetMixMatchData(String documentId) async {
    FirebaseFirestore.instance.collection('products').doc(documentId).update({
      'p_mixmatch': '',
      'p_mixmatch_colors': [],
      'p_mixmatch_sex': '',
      'p_mixmatch_desc': '',
      'p_mixmatch_collection': [],
    }).then((value) {
      print("MixMatch data reset to empty successfully.");
    }).catchError((error) {
      print("Failed to reset MixMatch data: $error");
    });
  }

  bool isDataComplete() {
    return pnameController.text.isNotEmpty &&
        pabproductController.text.isNotEmpty &&
        pdescController.text.isNotEmpty &&
        psizeController.text.isNotEmpty &&
        ppriceController.text.isNotEmpty &&
        pquantityController.text.isNotEmpty &&
        selectedCollection.isNotEmpty &&
        selectedSubcollection.isNotEmpty &&
        selectedGender.isNotEmpty &&
        selectedSizes.isNotEmpty &&
        selectedColorIndexes.isNotEmpty &&
        selectedMixandmatch.isNotEmpty ;
  }

  void resetForm() {
    pnameController.clear();
    pabproductController.clear();
    pdescController.clear();
    psizeController.clear();
    ppriceController.clear();
    pquantityController.clear();
    selectedColorIndexes.clear();
    selectedCollection.clear();
    pImagesLinks.clear();
    selectedSubcollection.value = '';
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
  final String gendermixmatch;
  final List<String> collectionsmixmatch;
  final List<String> colormixmatch;
  final List<String> imageUrls;

  Product({
    required this.id,
    required this.name,
    required this.vendorId,
    required this.part,
    required this.price,
    required this.gendermixmatch,
    required this.collectionsmixmatch,
    required this.colormixmatch,
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
      gendermixmatch: data['p_mixmatch_sex'] ?? '',
      collectionsmixmatch: List<String>.from(data['p_mixmatch_collection'] ?? []),
      colormixmatch: List<String>.from(data['p_mixmatch_colors'] ?? []),
      imageUrls: List<String>.from(data['p_imgs'] ?? []),
    );
  }
}

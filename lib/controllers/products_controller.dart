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

  var collectionsList = <String>[].obs;
  var typepfproductList = <String>[].obs;
  var subcollectionList = <String>[].obs;
  List<Collection> collection = [];
  var pImagesLinks = [];
  var pImagesList = RxList<dynamic>.generate(3, (index) => null);
  RxString selectedSize = ''.obs;
  List<String> sizesList = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  RxString selectedGender = ''.obs;
  List<String> genderList = ['Male', 'Female', 'Other'];
  RxString selectedSkinColor = ''.obs;
  List<Map<String, dynamic>> skinColorList = [
    {'name': 'Light', 'color': Color.fromARGB(255, 223, 209, 209)},
    {'name': 'Medium', 'color': Colors.brown[200]},
    {'name': 'Medium', 'color': Colors.brown[200]},
    {'name': 'Dark', 'color': Colors.brown[800]},
    {'name': 'Unspecified', 'color': Colors.brown},
  ];
  RxString selectedClothingColor = ''.obs;
  List<Map<String, dynamic>> clothingColorList = [
    {'name': 'Red', 'color': Colors.black},
    {'name': 'Red', 'color': Colors.grey},
    {'name': 'Red', 'color': Colors.white},
    {'name': 'Red', 'color': Colors.purple},
    {'name': 'Red', 'color': Colors.deepPurple},
    {'name': 'Red', 'color': Colors.blue},
    {'name': 'Red', 'color': Colors.blueGrey},
    {'name': 'Red', 'color': Colors.green},
    {'name': 'Red', 'color': Colors.greenAccent},
    {'name': 'Blue', 'color': Colors.yellow},
    {'name': 'Green', 'color': Colors.amberAccent},
    {'name': 'Black', 'color': Colors.orange},
    {'name': 'Black', 'color': Colors.orangeAccent},
    {'name': 'Black', 'color': Colors.red},
    {'name': 'Black', 'color': Colors.redAccent},
  ];
  RxInt selectedColorIndex = (-1).obs;
  List<Map<String, dynamic>> clothingColorLists = [
    {'name': 'Red', 'color': Colors.red},
    {'name': 'Blue', 'color': Colors.blue},
  ];
  RxString selectedMixAndMatch = ''.obs;
  List<String> mixAndMatchOptions = ['Top', 'Lower', 'Not Specified'];

  var collectionsvalue = ''.obs;
  var typeofproductvalue = ''.obs;
  var subcollectionvalue = ''.obs;
  // var selectedColorIndex = 0.obs;

  getCollection() async {
    var data =
        await rootBundle.loadString("lib/services/collection_model.json");
    var cat = collectionModelFromJson(data);
    collection = cat.collections;
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
      if (item != null) {
        var filename = basename(item.path);
        var destination = 'images/vendors/${currentUser!.uid}/$filename';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(item);
        var n = await ref.getDownloadURL();
        pImagesLinks.add(n);
      }
    }
  }

  uploadProduct(context) async {
    var store = firestore.collection(productsCollection).doc();
    await store.set({
      'is_featured': false,
      'p_collection': collectionsvalue.value,
      'P_typeofproduct': typeofproductvalue.value,
      'p_subcollection': subcollectionvalue.value,
      'p_colors': FieldValue.arrayUnion([Colors.red.value, Colors.brown.value]),
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
      'featured_id': ''
    });
    isloading(false);

    VxToast.show(context, msg: "Product Update");
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
}

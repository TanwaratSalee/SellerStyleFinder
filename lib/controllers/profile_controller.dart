import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'profile_controller.dart';
export 'package:get/get.dart';

class ProfileController extends GetxController {
  late QueryDocumentSnapshot snapshotData;

  var profileImgPath = ''.obs;

  var profileImageLink = '';

  var isloading = false.obs;

  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();
  var emailController = TextEditingController();

  var shopAddressController = TextEditingController();
  var shopCityController = TextEditingController();
  var shopStateController = TextEditingController();
  var shopPostalController = TextEditingController();
  var shopPhoneController = TextEditingController();  

  fetchUserData() async {
    isloading(true);
    try {
      // Fetch the document for the current user
      var editaccount = await FirebaseFirestore.instance
          .collection(vendorsCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Update text fields with data from Firestore
      nameController.text = editaccount.data()?['vendor_name'] ?? '';
      emailController.text = editaccount.data()?['email'] ?? '';
      shopPhoneController.text = editaccount.data()?['shop_mobile'] ?? '';

      // Fetch and handle addresses if available
      var addresses = editaccount.data()?['addresses'] as List<dynamic>? ?? [];
      if (addresses.isNotEmpty) {
        var firstAddress = addresses.first as Map<String, dynamic>;
        shopAddressController.text = firstAddress['address'] ?? '';
        shopCityController.text = firstAddress['city'] ?? '';
        shopStateController.text = firstAddress['state'] ?? '';
        shopPostalController.text = firstAddress['postalCode'] ?? '';
      } else {
        // Clear address fields if no addresses found
        shopAddressController.clear();
        shopCityController.clear();
        shopStateController.clear();
        shopPostalController.clear();
      }

      // Ensure email is not empty to avoid errors when capitalizing
      if (emailController.text.isNotEmpty) {
        emailController.text = emailController.text[0].toUpperCase() +
            emailController.text.substring(1);
      }

      isloading(false);
    } catch (e) {
      // Handle errors and ensure loading state is updated
      print('Error fetching user data: $e');
      isloading(false);
    }
  }

  // Select a photo from the user's gallery. /ImagePicker to open a gallery. / 70% to reduce file size.
  changeImage(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profileImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  // Upload the selected profile picture to Firebase Storage.
  uploadProfileImage() async {
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  // Uused to update Firebase Firestore profile information.
  updateProfile({name, imgUrl, address, city, state, postal, phone}) async {
    var store = FirebaseFirestore.instance
        .collection(vendorsCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid);
    var doc = await store.get();
    List<dynamic> addresses = doc.data()?['addresses'] ?? [];

    if (addresses.isNotEmpty) {
      addresses[0] = {
        'address': address,
        'city': city,
        'state': state,
        'postalCode': postal
      };
    } else {
      addresses.add({
        'address': address,
        'city': city,
        'state': state,
        'postalCode': postal
      });
    }
    await store.set(
        {
          'vendor_name': name, 
          'imageUrl': imgUrl, 
          'addresses': addresses,
          'shop_mobile' : phone, // Ensure the phone field is included
        },
        SetOptions(merge: true));

    isloading(false);
  }

  // Change password
  changeAuthPassword({email, password, newpassword}) async {
    final card = EmailAuthProvider.credential(email: email, password: password);

    await currentUser!.reauthenticateWithCredential(card).then((value) {
      currentUser!.updatePassword(newpassword);
    }).catchError((error) {
      // ignore: avoid_print
      print(error.toString());
    });
  }

  updateShop({shopname, shopaddress, shopmobile, shopwebsite, shopdesc}) async {
    var store = firestore.collection(vendorsCollection).doc(currentUser!.uid);
    await store.set(
      {
        'shop_name': shopname,
        'shop_address': shopaddress,
        'shop_mobile': shopmobile,
        'shop_website': shopwebsite,
        'shop_desc': shopdesc
      },
      SetOptions(merge: true),
    );
    isloading(false);
  }
}

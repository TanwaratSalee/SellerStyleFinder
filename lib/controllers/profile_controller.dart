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

  var shopNameController = TextEditingController();
  var shopfullnameController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopMobileController = TextEditingController();
  var shopWebsiteController = TextEditingController();
  var shopDescController = TextEditingController();

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
  updateProfile({name, password, imgUrl}) async {
    var store = firestore.collection(vendorsCollection).doc(currentUser!.uid);
    store.set({'vendor_name': name, 'password': password, 'imageUrl': imgUrl},
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

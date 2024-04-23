import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/views/auth_screen/create_screen.dart';
import 'package:seller_finalproject/views/home_screen/home.dart';
import 'package:path/path.dart';
import 'dart:io';

class AuthController extends GetxController {
  var isloading = false.obs;
  Rx<XFile?> imageFile = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();



  //textcontrollers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var shopNameController = TextEditingController();
  var mobileController = TextEditingController();
  var websiteController = TextEditingController();
  var descriptionController = TextEditingController();

  //login method
  // Future<UserCredential?> loginMethod({context}) async {
  //   UserCredential? userCredential;
  //   try {
  //     userCredential = await auth.signInWithEmailAndPassword(
  //         email: emailController.text, password: passwordController.text);
  //   } on FirebaseAuthException catch (e) {
  //     VxToast.show(context, msg: e.toString());
  //   }
  //   return userCredential;
  //   }

  //   Future<void> loginMethod({required BuildContext context}) async {
  //   isloading(true);
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );
  //     await checkVendorData(userCredential.user!.uid, context);
  //   } on FirebaseAuthException catch (e) {
  //     isloading(false);
  //     Get.snackbar("Login Error", e.message ?? "An error occurred during login.",
  //         snackPosition: SnackPosition.BOTTOM);
  //   }
  // }

  //Signout method
  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  //Check account have vendors
  Future<void> checkVendorData(String userId, BuildContext context) async {
    var vendorDoc = await FirebaseFirestore.instance.collection(vendorsCollection).doc(userId).get();
    isloading(false);
    if (!vendorDoc.exists) {
      Get.offAll(() => const CreateAccount());
    } else {
      Get.snackbar("Login Success", "Logged in successfully",
          snackPosition: SnackPosition.BOTTOM);
      Get.offAll(() => const Home());
    }
  }

  //signup account
Future<void> loginMethod() async {
  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
    return;
  }

  try {
    isloading.value = true;

    var userEmail = emailController.text.trim().toLowerCase();
    var userCredential = await auth.signInWithEmailAndPassword(
        email: userEmail,
        password: passwordController.text.trim());

    if (userCredential.user != null) {
      var vendorSnapshot = await firestore
          .collection('vendors')
          .where('email', isEqualTo: userEmail)
          .get();

      if (vendorSnapshot.docs.isEmpty) {
        Get.offAll(() => const CreateAccount());
      } else {
        Get.offAll(() => const Home());
      }
    }
  } on FirebaseAuthException catch (e) {
    print(e.message);
  } finally {
    isloading.value = false;
  }
}


Future<void> CreateAccountMethod(BuildContext context, Map<String, String> addressDetails) async {
  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
    VxToast.show(context, msg: "Please enter all required fields.");
    return;
  }

  isloading.value = true;

  try {
    String imageUrl = '';
    if (imageFile.value != null) {
      var file = File(imageFile.value!.path);
      var filename = basename(file.path);
      var destination = 'images/vendors/${FirebaseAuth.instance.currentUser?.uid}/$filename';
      Reference ref = FirebaseStorage.instance.ref(destination);
      await ref.putFile(file);
      imageUrl = await ref.getDownloadURL();
    }

    var userRef = FirebaseFirestore.instance.collection('vendors').doc(FirebaseAuth.instance.currentUser?.uid);
    await userRef.set({
      'email': emailController.text.trim().toLowerCase(),
      'id': FirebaseAuth.instance.currentUser?.uid,
      'imageUrl': imageUrl,
      'shop_desc': descriptionController.text,
      'shop_website': websiteController.text,
      'shop_mobile': mobileController.text,
      'vendor_name': shopNameController.text,
      'vendor_id': FirebaseAuth.instance.currentUser?.uid,
      'addresses': [addressDetails]
    });

    VxToast.show(context, msg: "Account successfully created.");
    Get.offAll(() => const Home());
  } catch (e) {
    VxToast.show(context, msg: "Error: ${e.toString()}");
  } finally {
    isloading.value = false;
  }
}




void clearAllData() {
  emailController.clear();
  passwordController.clear();
  shopNameController.clear();
  mobileController.clear();
  websiteController.clear();
  descriptionController.clear();
  imageFile.value = null; // Clear the selected image
}


  //image
  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile.value = pickedFile; // Correctly updating the Rx value
        update(); // This might not be necessary unless you have other reactive states to update
      }
    } catch (e) {
      print('Image picker error: $e');
    }
  }
}

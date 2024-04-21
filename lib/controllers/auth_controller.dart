import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/views/auth_screen/create_screen.dart';
import 'package:seller_finalproject/views/home_screen/home.dart';

class AuthController extends GetxController {
  var isloading = false.obs;
  XFile? imageFile;
  final ImagePicker _picker = ImagePicker();


  //textcontrollers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var shopNameController = TextEditingController();

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

      var userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      if (userCredential.user != null) {
        var vendorSnapshot = await firestore
            .collection('vendors')
            .where('email', isEqualTo: emailController.text.trim())
            .get();

        if (vendorSnapshot.docs.isEmpty) {
          Get.to(() => CreateAccount());
        } else {
          Get.offAll(() => Home());
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } finally {
      isloading.value = false;
    }
  }

  //image
  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        (() {
          imageFile = pickedFile;
        });
      }
    } catch (e) {
      print('Image picker error: $e');
    }
  }
}

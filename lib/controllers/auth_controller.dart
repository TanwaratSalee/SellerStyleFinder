import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/controllers/create_screen.dart';
import 'package:seller_finalproject/views/home_screen/home.dart';

class AuthController extends GetxController {

  var isloading = false.obs;

  //textcontrollers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var shopnNameController = TextEditingController();

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

    Future<void> loginMethod({required BuildContext context}) async {
    isloading(true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await checkVendorData(userCredential.user!.uid, context);
    } on FirebaseAuthException catch (e) {
      isloading(false);
      Get.snackbar("Login Error", e.message ?? "An error occurred during login.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

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
    var vendorDoc = await FirebaseFirestore.instance.collection('vendors').doc(userId).get();
    isloading(false);
    if (!vendorDoc.exists) {
      Get.offAll(() => CreateAccount());
    } else {
      Get.snackbar("Login Success", "Logged in successfully",
          snackPosition: SnackPosition.BOTTOM);
      Get.offAll(() => const Home());
    }
  }

  Future<void> signupMethod(String userId, BuildContext context) async {
    var vendorDoc = await FirebaseFirestore.instance.collection('vendors').doc(userId).get();
    isloading(false);
    if (!vendorDoc.exists) {
      Get.offAll(() => CreateAccount());
    } else {
      Get.snackbar("Login Success", "Logged in successfully",
          snackPosition: SnackPosition.BOTTOM);
      Get.offAll(() => const Home());
    }
  }
}

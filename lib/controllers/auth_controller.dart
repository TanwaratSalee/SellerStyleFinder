import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/views/auth_screen/create_screen.dart';
import 'package:seller_finalproject/views/auth_screen/creategoogle_screen.dart';
import 'package:seller_finalproject/views/home_screen/home.dart';
import 'package:path/path.dart';
import 'dart:io';

class AuthController extends GetxController {
  var isloading = false.obs;
  Rx<XFile?> imageFile = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();

  var firstnameController = TextEditingController().obs;
  var surnameController = TextEditingController().obs;
  var addressController = TextEditingController().obs;
  var cityController = TextEditingController().obs;
  var stateController = TextEditingController().obs;
  var postalCodeController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;
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
    var vendorDoc = await FirebaseFirestore.instance
        .collection(vendorsCollection)
        .doc(userId)
        .get();
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
  Future<void> loginMethod(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      isloading.value = true;

      var userEmail = emailController.text.trim().toLowerCase();
      var userCredential = await auth.signInWithEmailAndPassword(
          email: userEmail, password: passwordController.text.trim());

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    } finally {
      isloading.value = false;
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    isloading.value = true;

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final String email = userCredential.user?.email ?? "No Email";
      final String name = userCredential.user?.displayName ?? "No Name";
      final String uid = userCredential.user?.uid ?? "";

      // Check if the user's uid exists in Firestore
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userCredential.user != null) {
        var vendorSnapshot = await await FirebaseFirestore.instance
            .collection('vendors')
            .where('email', isEqualTo: email)
            .get();

        if (vendorSnapshot.docs.isEmpty) {
          Get.offAll(() => CreateAccountGoogle(email: email, uid: uid));
        } else {
          Get.offAll(() => const Home());
        }
      }
    } catch (e) {
      print("Error signing in with Google: $e");
    } finally {
      isloading.value = false;
    }
  }

  Future<void> CreateAccountMethod(
      BuildContext context, Map<String, String> addressDetails) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      VxToast.show(context, msg: "Please enter all required fields.");
      return;
    }

    isloading.value = true;

    try {
      String imageUrl =
          'https://firebasestorage.googleapis.com/v0/b/new-tung.appspot.com/o/images%2FCs77utvw41dPiruedA7worPnUUj1%2Fimage_picker_0B4BC2B2-A8E1-4F17-96B7-E638F473E164-97366-000003F7D0AB776D.png?alt=media&token=aa53d66f-a313-422e-8d45-7042212ebb36';
      if (imageFile.value != null) {
        var file = File(imageFile.value!.path);
        var filename = basename(file.path);
        var destination =
            'images/vendors/${FirebaseAuth.instance.currentUser?.uid}/$filename';
        Reference ref = FirebaseStorage.instance.ref(destination);
        await ref.putFile(file);
        imageUrl = await ref.getDownloadURL();
      }

      var userRef = FirebaseFirestore.instance
          .collection(vendorsCollection)
          .doc(FirebaseAuth.instance.currentUser?.uid);
      await userRef.set({
        'vendor_id': FirebaseAuth.instance.currentUser?.uid,
        'name': shopNameController.text,
        'email': emailController.text.trim().toLowerCase(),
        'imageUrl': imageUrl,
        'official' : false,
        'description': descriptionController.text,
        'website': websiteController.text,
        'mobile': mobileController.text,
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
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile.value = pickedFile;
        update();
      }
    } catch (e) {
      print('Image picker error: $e');
    }
  }
}

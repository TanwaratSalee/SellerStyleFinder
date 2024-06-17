// ignore_for_file: use_build_context_synchronously

import 'dart:ffi';
import 'dart:io';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';

import '../../const/const.dart';
import '../widgets/edit_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  final String? username;
  const EditProfileScreen({super.key, this.username});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    controller.fetchUserData().then((_) {
      controller.nameController.text = controller.snapshotData['vendor_name'];
      controller.emailController.text = controller.snapshotData['email'];
      controller.shopPhoneController.text = controller.snapshotData['shop_mobile'] ?? '';

      String email = controller.snapshotData['email'] ?? '';
      controller.emailController.text =
          email.isNotEmpty ? email[0].toUpperCase() + email.substring(1) : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text(
            Shopaccout,
            style: TextStyle(fontFamily: medium, fontSize: 24),
          ),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: primaryApp)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);

                      if (controller.profileImgPath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImageLink =
                            controller.snapshotData['imageUrl'];
                      }

                      // Pass all updated fields to updateProfile
                      await controller.updateProfile(
                        name: controller.nameController.text,
                        imgUrl: controller.profileImageLink,
                        address: controller.shopAddressController.text,
                        city: controller.shopCityController.text,
                        state: controller.shopStateController.text,
                        postal: controller.shopPostalController.text,
                        phone: controller.shopPhoneController.text, // Pass phone parameter
                      );

                      VxToast.show(context,
                          msg: "Profile updated successfully");

                      controller.isloading(false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                            fontFamily: medium, color: greyDark, fontSize: 16),
                      ),
                    ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //if data image url and contoller path is empty
                controller.snapshotData['imageUrl'] == '' &&
                        controller.profileImgPath.isEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          imgProfile,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                        .box
                        .roundedFull
                        .border(color: greyColor, width: 2)
                        .make()
                    // if data is not empty but controller path is empty
                    : controller.snapshotData['imageUrl'] != '' &&
                            controller.profileImgPath.isEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              controller.snapshotData['imageUrl'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                            .box
                            .roundedFull
                           .border(color: greyLine, width: 2)
                            .make()
                        //if both are emtpy
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              File(controller.profileImgPath.value),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                            .box
                            .roundedFull
                            .border(color: greyLine, width: 2)
                            .make(),
                
                10.heightBox,
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      " About Account",
                      style: TextStyle(
                        color: greyDark,
                        fontFamily: medium,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),

                const Divider(
                  color: greyThin,
                ),
                15.heightBox,
                editTextField(
                  label: 'Shop Name :',
                  controller: controller.nameController,
                ),
                10.heightBox,
                editTextField(
                    label: 'Email :',
                    controller: controller.emailController,
                    isPass: false,
                    readOnly: true),
                40.heightBox,
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    address2,
                    style: TextStyle(fontFamily: medium),
                  ).text.size(20).fontFamily(medium).color(blackColor).make(),
                ),
                const Divider(color: greyThin),
                editTextField(
                  label: address,
                  controller: controller.shopAddressController,
                ),
                10.heightBox,
                editTextField(
                  label: city,
                  controller: controller.shopCityController,
                ),
                editTextField(
                  label: state,
                  controller: controller.shopStateController,
                ),
                10.heightBox,
                editTextField(
                  label: postal,
                  controller: controller.shopPostalController,
                ),
                10.heightBox,
                editTextField(
                  label: 'Phone :',
                  controller: controller.shopPhoneController,
                ),
                10.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

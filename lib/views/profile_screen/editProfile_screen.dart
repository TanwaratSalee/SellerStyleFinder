// ignore_for_file: use_build_context_synchronously

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

      String email = controller.snapshotData['email'] ?? '';
      controller.emailController.text = email[0].toUpperCase() + email.substring(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text(editshopProfile),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: primaryApp)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);

                      //if image is not selected
                      if (controller.profileImgPath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImageLink =
                            controller.snapshotData['imageUrl'];
                      }

                      //if old password matches data
                      if (controller.snapshotData['password'] ==
                          controller.oldpassController.text) {
                        await controller.changeAuthPassword(
                            email: controller.snapshotData['email'],
                            password: controller.oldpassController.text,
                            newpassword: controller.newpassController.text);

                        await controller.updateProfile(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.newpassController.text);
                        VxToast.show(context, msg: "Updated");
                      } else if (controller
                              .oldpassController.text.isEmptyOrNull &&
                          controller.newpassController.text.isEmptyOrNull) {
                        await controller.updateProfile(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.snapshotData['password']);
                        VxToast.show(context, msg: "Updated");
                      } else {
                        VxToast.show(context, msg: "Some error occured");
                        controller.isloading(false);
                      }
                    },
                    child: const Text(save))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
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
                              fit: BoxFit.cover,
                            ),
                          )
                            .box
                            .roundedFull
                            .border(color: greyColor, width: 2)
                            .make()
                        //if both are emtpy
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              File(controller.profileImgPath.value),
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                            .box
                            .roundedFull
                            .border(color: greyColor, width: 2)
                            .make(),

                10.heightBox,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryApp,
                      textStyle: TextStyle(color: whiteColor)),
                  onPressed: () {
                    controller.changeImage(context);
                  },
                  child: const Text(changeImage),
                ),
                20.heightBox,

                Align(
                alignment: Alignment.centerLeft,
                child: const Text(aboutaccount)
                    .text
                    .size(20)
                    .fontFamily(medium)
                    .color(blackColor)
                    .make(),
              ),
              
              const Divider(color: thinGrey0,),
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
                  readOnly: true
                ),
                40.heightBox,
                Align(
                alignment: Alignment.centerLeft,
                child: const Text(address)
                    .text
                    .size(20)
                    .fontFamily(medium)
                    .color(blackColor)
                    .make(),
              ),
              const Divider(color: thinGrey0),
              editTextField(
                  label: address,
                  controller: controller.shopAddressController,
                ),
                10.heightBox,
                editTextField(
                  label: city,
                  controller: controller.shopCityController,
                  isPass: false,
                  readOnly: true
                ),
                editTextField(
                  label: state,
                  controller: controller.shopStateController,
                ),
                10.heightBox,
                editTextField(
                  label: postal,
                  controller: controller.shopPostalController,
                  isPass: false,
                  readOnly: true
                ),
                10.heightBox,
                // const Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //        "Change your password"),
                // ),
                // 10.heightBox,
                // customTextField(
                //     label: password, controller: controller.oldpassController),
                // 10.heightBox,
                // customTextField(
                //     label: confirmPass,
                //     controller: controller.newpassController),
                10.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

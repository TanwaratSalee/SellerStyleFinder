// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';
import 'package:seller_finalproject/views/widgets/text_style.dart';

import '../../const/const.dart';

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
    controller.nameController.text = widget.username!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: boldText(text: editshopProfile, color: fontBlack, size: 30.0),
          actions: [
            controller.isloading.value
                ? loadingIndcator(circleColor: primaryApp)
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
                    child: normalText(text: save, color: fontBlack))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //if data image url and contoller path is empty
                controller.snapshotData['imageUrl'] == '' &&
                        controller.profileImgPath.isEmpty
                    ? Image.asset(
                        imgProfile,
                        width: 100,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make()
                    // if data is not empty but controller path is empty
                    : controller.snapshotData['imageUrl'] != '' &&
                            controller.profileImgPath.isEmpty
                        ? Image.network(
                            controller.snapshotData['imageUrl'],
                            width: 100,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make()
                        //if both are emtpy
                        : Image.file(
                            File(controller.profileImgPath.value),
                            width: 100,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make(),

                // Image.asset(imgProduct, width: 150).box.roundedFull.clip(Clip.antiAlias).make(),
                10.heightBox,
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryApp),
                    onPressed: () {
                      controller.changeImage(context);
                    },
                    child: normalText(text: changeImage)),
                20.heightBox,
                const Divider(),
                20.heightBox,
                customTextField(
                  label: shopName,
                  controller: controller.shopNameController,
                ),
                20.heightBox,
                customTextField(
                  label: email,
                  controller: controller.emailController,
                ),
                20.heightBox,
                Align(
                  alignment: Alignment.centerLeft,
                  child: boldText(
                      text: "Change your password", color: fontGreyDark),
                ),
                10.heightBox,
                customTextField(
                    label: password, controller: controller.oldpassController),
                10.heightBox,
                customTextField(
                    label: confirmPass,
                    controller: controller.newpassController),
                10.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

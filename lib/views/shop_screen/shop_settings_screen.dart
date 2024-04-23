import 'dart:io';

import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/controllers/profile_controller.dart';
export 'package:get/get.dart';

class ShopSettings extends StatelessWidget {
  const ShopSettings({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text( shopSettings),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: greyColor)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
                      await controller.updateShop(
                          shopaddress: controller.shopAddressController.text,
                          shopname: controller.shopNameController.text,
                          shopmobile: controller.shopMobileController.text,
                          shopwebsite: controller.shopWebsiteController.text,
                          shopdesc: controller.shopDescController.text);
                      // ignore: use_build_context_synchronously
                      VxToast.show(context, msg: "Shop updated");
                    },
                    child: const Text(save))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            controller.snapshotData['imageUrl'] == '' &&
                    controller.profileImgPath.isEmpty
                ? Image.asset(
                    imgProfile,
                    width: 100,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make()
                : controller.snapshotData['imageUrl'] != '' &&
                        controller.profileImgPath.isEmpty
                    ? Image.network(
                        controller.snapshotData['imageUrl'],
                        width: 150,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make()
                    : Image.file(
                        File(controller.profileImgPath.value),
                        width: 150,
                        fit: BoxFit.cover,
                      ).box.roundedFull.clip(Clip.antiAlias).make(),
            10.heightBox,
            const Text( " About Shop"),
            10.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text( "Fullname: "),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(
                    controller.shopfullnameController.text,
                    style: const TextStyle(
                      color: greyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
            ),
            10.heightBox,
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text( "Email: "),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.emailController.text,
                        style: const TextStyle(
                          color: greyColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )),
            10.heightBox,
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text( "Address: "),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.shopAddressController.text,
                        style: const TextStyle(
                          color: greyColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )),
            10.heightBox,
          ]),
        ),
      ),
    );
  }
}

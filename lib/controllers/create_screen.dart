import 'package:get/get.dart';
import 'package:seller_finalproject/controllers/auth_controller.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/views/widgets/our_button.dart';

import '../const/const.dart';
import '../const/styles.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
          title: Text("Create Shop Account").text.size(24).fontFamily(medium).make(),
          backgroundColor: Colors.white,
        elevation: 0,
        ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              200.heightBox,
              Obx(
                () => Column(
                  children: [
                    TextFormField(
                      controller: controller.shopnNameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Shop Name',
                      ),
                    )
                        .box
                        .white
                        .rounded
                        .outerShadowMd
                        .padding(const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 22))
                        .make(),
                    40.heightBox,
                    SizedBox(
                      child: controller.isloading.value
                          ? loadingIndicator()
                          : ourButton(
                              title: 'Next',
                              onPress: () async {
                                // await controller.signupMethod();
                              },
                            ),
                    ),
                  ],
                )
                    .box
                    .padding(const EdgeInsets.all(20.0))
                    .make(),
              ),
              10.heightBox,
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

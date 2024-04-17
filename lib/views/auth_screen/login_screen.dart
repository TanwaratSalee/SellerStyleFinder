import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/auth_controller.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/views/home_screen/home.dart';
import 'package:seller_finalproject/views/widgets/our_button.dart';
import 'package:seller_finalproject/views/widgets/text_style.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryApp,
        body: Container(
          decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(imgBg),
            fit: BoxFit.cover,
          ),
      ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // 30.heightBox,
                // normalText(text: welcome, size: 18.0),
                // 20.heightBox,
                // Row(
                //   children: [
                //     Image.asset(
                //       icLogo,
                //       width: 70,
                //       height: 70,
                //     )
                //         .box
                //         .border(color: whiteColor)
                //         .rounded
                //         .padding(const EdgeInsets.all(8.0))
                //         .make(),
                //     10.widthBox,
                //     boldText(text: appname, size: 20.0)
                //   ],
                // ),
                200.heightBox,
                
                Obx(() => Column(
                    children: [
                      Text(loginTo,).text.size(24).color(blackColor).fontFamily(medium).make(),
                      40.heightBox,
                      TextFormField(
                        controller: controller.emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: greyColor,
                          ),
                          border: InputBorder.none,
                          hintText: email,
                        ),
                      )
                          .box
                          .white
                          .rounded
                          .outerShadowMd
                          .padding(const EdgeInsets.all(8.0))
                          .make(),
                      10.heightBox,
                      TextFormField(
                        obscureText: true,
                        controller: controller.passwordController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: greyColor,
                          ),
                          border: InputBorder.none,
                          hintText: password,
                        ),
                      )
                          .box
                          .white
                          .rounded
                          .outerShadowMd
                          .padding(const EdgeInsets.all(8.0))
                          .make(),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {},
                              child: normalText(
                                  text: forgotPassword, color: greyDark2))),
                      20.heightBox,
                      SizedBox(
                        child: controller.isloading.value
                            ? loadingIndicator()
                            : ourButton(
                                title: login,
                                onPress: () async {
                                  controller.isloading(true);
                
                                  await controller
                                      .loginMethod(context: context)
                                      .then((value) {
                                    if (value != null) {
                                      VxToast.show(context, msg: "Logged in successfully");
                                      controller.isloading(false);
                                      Get.offAll(() => const Home());
                                    } else {
                                      controller.isloading(false);
                                    }
                                  });
                                },
                              ),
                      ),
                    ],
                  )
                      .box
                      .white
                      .rounded
                      .outerShadowMd
                      .padding(const EdgeInsets.all(20.0))
                      .make(),
                ),
                10.heightBox,
                // Center(child: normalText(text: anyProblem, color: whiteColor)),
                const Spacer(),
                // Center(
                //   child: boldText(text: credit),
                // ),
              ],
            ),
          ),
        ),
      
    );
  }
}

import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/auth_controller.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/views/auth_screen/forgot_screen.dart';
import 'package:seller_finalproject/views/widgets/our_button.dart';

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
                200.heightBox,
                
                Obx(() => Column(
                    children: [
                      const Text(loginTo).text.size(36).color(blackColor).fontFamily(medium).make(),
                      20.heightBox,
                      TextFormField(
                        controller: controller.emailController,
                        decoration: const InputDecoration(
                          // prefixIcon: Icon(
                          //   Icons.email,
                          //   color: greyColor,
                          // ),
                          border: InputBorder.none,
                          hintText: email,
                        ),
                      )
                          .box
                          .white
                          .rounded
                          .outerShadowMd
                          .padding(const EdgeInsets.symmetric(vertical: 8,horizontal: 22))
                          .make(),
                      10.heightBox,
                      TextFormField(
                        obscureText: true,
                        controller: controller.passwordController,
                        decoration: const InputDecoration(
                          // prefixIcon: Icon(
                          //   Icons.lock,
                          //   color: greyColor,
                          // ),
                          border: InputBorder.none,
                          hintText: password,
                        ),
                      )
                          .box
                          .white
                          .rounded
                          .outerShadowMd
                          .padding(const EdgeInsets.symmetric(vertical: 8,horizontal: 22))
                          .make(),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {
                                Get.to(() => ForgotScreen());
                              },
                              child: const Text(
                                   forgotPassword).text.size(14).color(greyDark1).fontFamily(medium).make())),
                      10.heightBox,
                      SizedBox(
                        child: controller.isloading.value
                            ? loadingIndicator()
                            :  ourButton(
                            title: 'Login',
                            onPress: () async {
                              await controller.loginMethod();
                            },
                          ),
                            // : ourButton(
                            //     title: login,
                            //     onPress: () async {
                            //       controller.isloading(true);
                            //       await controller
                            //           .loginMethod(context: context)
                            //           .then((value) {
                            //         if (value != null) {
                            //           VxToast.show(context, msg: "Logged in successfully");
                            //           controller.isloading(false);
                            //           Get.offAll(() => const Home());
                            //         } else {
                            //           controller.isloading(false);
                            //         }
                            //       });
                            //     },
                            //   ),
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
                // Center(child: Text(text: anyProblem, color: whiteColor)),
                const Spacer(),
                // Center(
                //   child: Text(text: credit),
                // ),
              ],
            ),
          ),
        ),
      
    );
  }
}

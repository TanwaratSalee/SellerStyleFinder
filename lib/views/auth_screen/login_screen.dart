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

              Obx(
                () => Column(
                  children: [
                    const Text(loginTo)
                        .text
                        .size(36)
                        .color(blackColor)
                        .fontFamily(medium)
                        .make(),
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
                        .padding(const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 22))
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
                        .padding(const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 22))
                        .make(),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              Get.to(() => ForgotScreen());
                            },
                            child: const Text(forgotPassword)
                                .text
                                .size(14)
                                .color(greyDark1)
                                .fontFamily(medium)
                                .make())),
                    10.heightBox,
                    SizedBox(
                      child: controller.isloading.value
                          ? loadingIndicator()
                          : ourButton(
                              title: 'Login',
                              onPress: () async {
                                await controller.loginMethod();
                              },
                            ),
                    ),
                    30.heightBox,
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: greyDark1, height: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: loginWith.text.color(greyDark2).make(),
                        ),
                        const Expanded(
                          child: Divider(color: greyDark1, height: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        socialIconList.length,
                        (index) => GestureDetector(
                          onTap: () {
                            switch (index) {
                              case 0: // Google
                                // controller.signInWithGoogle(context);
                                break;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: greyColor,
                                width: 1,
                              ),
                            ),
                            child: Image.asset(
                              socialIconList[index],
                              width: 80,
                              height: 24,
                            ),
                          ),
                        ),
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
              // Center(child: Text(text: anyProblem, color: whiteColor)),\
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

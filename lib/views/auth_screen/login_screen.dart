import 'package:flutter/material.dart';
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            100.heightBox,
            Obx(
              () => Column(
                children: [
                  const Text(loginTo)
                      .text
                      .size(36)
                      .color(blackColor)
                      .fontFamily(medium)
                      .make(),
                  Image.asset(
                    icbag,
                    width: 320,
                    height: 320,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                            'Enjoy selling and discovering the best fashion brands. Wishing you a successful first day!')
                        .text
                        .align(TextAlign.center)
                        .size(14)
                        .color(greyColor)
                        .make(),
                  ),
                  30.heightBox,
                  Container(
                    width: 360,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: greyLine, width: 1),
                    ),
                    child: TextFormField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: email,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                      ),
                    ),
                  ),
                  10.heightBox,
                  Container(
                    width: 360,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: greyLine, width: 1),
                    ),
                    child: TextFormField(
                      obscureText: true,
                      controller: controller.passwordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: password,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => ForgotScreen());
                        },
                        child: const Text(forgotPassword)
                            .text
                            .size(14)
                            .color(greyDark)
                            .fontFamily(medium)
                            .make(),
                      ),
                    ),
                  ),
                  10.heightBox,
                  SizedBox(
                    child: controller.isloading.value
                        ? loadingIndicator()
                        : ourButton(
                            title: 'Sign In',
                            onPress: () async {
                              await controller.loginMethod();
                            },
                          ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Container(
                          height: 720,
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "How to Sign Up for the Seller StyleFinder App",
                                style: TextStyle(
                                    fontSize: 32, fontFamily: semiBold),
                              ),
                              SizedBox(height: 40),
                              const Text(
                                'If you already have an account with the StyleFinder app, you can seamlessly use the same email and password to create your store with us.',
                                style: TextStyle(
                                    fontSize: 16, fontFamily: regular),
                              ),
                              20.heightBox,
                              Text(
                                    'If you do not yet have an account with the StyleFinder app, please follow these steps:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: regular,
                                    ),
                                  ),
                              
                              Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    SizedBox(height: 8),
                                    Text(
                                      '1. Download the StyleFinder app.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: regular,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '2. Register and log in using the app.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: regular,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '3. Once registered, you can use the same email and password to create your store account through the Seller StyleFinder app.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: regular,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 70),
                              const Text(
                                'Thank you for choosing StyleFinder to meet your fashion needs. We sincerely hope that you will enjoy and appreciate our service.',
                                style: TextStyle(
                                    fontSize: 18, fontFamily: regular),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text(
                    "How to Sign Up for the Seller StyleFinder App",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                      color: blackColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

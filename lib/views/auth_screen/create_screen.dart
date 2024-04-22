import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/colors.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/firebase_consts.dart';
import 'package:seller_finalproject/controllers/auth_controller.dart';
import 'package:seller_finalproject/controllers/editaddress_controller.dart';
import 'package:seller_finalproject/controllers/loading_Indcator.dart';
import 'package:seller_finalproject/views/widgets/our_button.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final AuthController controller = Get.find<AuthController>();

  @override
  void dispose() {
    controller.clearAllData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Create Shop Account"),
        backgroundColor: whiteColor,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
                  InkWell(
                    onTap: controller.pickImage,
                    child: Obx(() => CircleAvatar(
                      radius: 60,
                      backgroundColor: thinGrey01,
                      child: controller.imageFile.value == null
                        ? Icon(Icons.add_a_photo, color: greyColor, size: 50)
                        : ClipOval(
                            child: Image.file(
                              File(controller.imageFile.value!.path),
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                            ),
                          ),
                    )),
                  ),
              const SizedBox(height: 20),
              Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller.shopNameController,
                      decoration: InputDecoration(
                        labelText: 'Shop Name',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),SizedBox(height: 20),
                    TextField(
                      controller: controller.descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),SizedBox(height: 20),
                    TextField(
                      controller: controller.websiteController,
                      decoration: InputDecoration(
                        labelText: 'Website',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),SizedBox(height: 20),
                    TextField(
                      controller: controller.mobileController,
                      decoration: InputDecoration(
                        labelText: 'Mobile',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 20),
                    controller.isloading.value
                            ? loadingIndicator()
                            :  ourButton(
                        title: 'Next',
                        onPress: () {
                          if (controller.emailController.text.isEmpty ||
                              controller.passwordController.text.isEmpty ||
                              controller.shopNameController.text.isEmpty ||
                              controller.mobileController.text.isEmpty ||
                              controller.websiteController.text.isEmpty ||
                              controller.descriptionController.text.isEmpty) {
                            VxToast.show(context, msg: "Please fill all fields.");
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => editaddress_controller(
                              documentId: currentUser?.uid ?? '',
                              firstname: '',
                              surname: '',
                              address: '',
                              city: '',
                              state: '',
                              postalCode: '',
                              phone: '',
                            )),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
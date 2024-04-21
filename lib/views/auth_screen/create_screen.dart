import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/colors.dart';
import 'package:seller_finalproject/controllers/auth_controller.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Create Shop Account"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // To change the back button color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: controller.pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: thinGrey01,
                  child: controller.imageFile == null
                      ? Icon(Icons.add_a_photo, color: greyColor, size: 50)
                      : ClipOval(
                          child: Image.file(
                            File(controller.imageFile!.path),
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          ),
                        ),
                ),
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
                    ),
                    const SizedBox(height: 20),
                    controller.isloading.value
                            ? loadingIndicator()
                            :  ourButton(
                            title: 'Next',
                            onPress: () async {
                              await controller.loginMethod();
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
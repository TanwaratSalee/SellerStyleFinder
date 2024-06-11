import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/auth_controller.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';
import 'package:seller_finalproject/views/widgets/our_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddressForm extends StatefulWidget {
  final String documentId;
  final String firstname;
  final String surname;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String phone;

  AddressForm({
    Key? key,
    required this.documentId,
    required this.firstname,
    required this.surname,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.phone,
  }) : super(key: key);

  @override
  _AddressFormFormState createState() => _AddressFormFormState();
}

class _AddressFormFormState extends State<AddressForm> {
  final AuthController controller = Get.put(AuthController());

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingAnimationWidget.inkDrop(
                  color: primaryApp,
                  size: 50,
                ),
                const SizedBox(height: 20),
                const Text("Saving...", style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text("Shop Address").text.size(24).fontFamily(medium).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 45,
        child: ourButton(
          onPress: () async {
            if (controller.addressController.value.text.isEmpty ||
                controller.cityController.value.text.isEmpty ||
                controller.stateController.value.text.isEmpty ||
                controller.postalCodeController.value.text.isEmpty) {
              VxToast.show(context, msg: "All fields are required.");
              return;
            }
            showLoadingDialog();
            Map<String, String> addressDetails = {
              'address': controller.addressController.value.text,
              'city': controller.cityController.value.text,
              'state': controller.stateController.value.text,
              'postalCode': controller.postalCodeController.value.text,
            };
            await Get.find<AuthController>().CreateAccountMethod(context, addressDetails);

            Navigator.pop(context);
          },
          color: primaryApp,
          textColor: whiteColor,
          title: "Save",
        ),
      ).box.padding(EdgeInsets.fromLTRB(25, 0, 25, 40)).make(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              20.heightBox,
              Image.asset(imgAddress,width: 250,
                    height: 250,),
              customTextField(
                label: "Address",
                controller: controller.addressController.value,
              ),
              15.heightBox,
              customTextField(
                label: "City",
                controller: controller.cityController.value,
              ),
              15.heightBox,
              customTextField(
                label: "State",
                controller: controller.stateController.value,
              ),
              15.heightBox,
              customTextField(
                label: "Postal Code",
                controller: controller.postalCodeController.value,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

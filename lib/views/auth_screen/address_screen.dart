import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/address_controller.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';
import 'package:seller_finalproject/views/widgets/our_button.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({Key? key}) : super(key: key);

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final AddressController controller = Get.find<AddressController>();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            "Add Address".text.fontFamily(medium).color(greyDark2).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ourButton(
            onPress: () {
              
            },
            color: primaryApp,
            textColor: whiteColor,
            title: "Save"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              customTextField(
                  label: "Firstname",
                  controller: controller.firstnameController),
              customTextField(
                  label: "Surname",
                  controller: controller.surnameController),
              customTextField(
                  label: "Address",
                  controller: controller.addressController),
              customTextField(
                  label: "City",
                  controller: controller.cityController),
              customTextField(
                  label: "State",
                  controller: controller.stateController),
              customTextField(
                  label: "Postal Code",
                  controller: controller.postalCodeController),
              customTextField(
                  label: "Phone",
                  controller: controller.phoneController),
            ],
          ),
        ),
      ),
    );
  }
}

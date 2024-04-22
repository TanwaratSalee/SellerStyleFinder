import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/controllers/auth_controller.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';
import 'package:seller_finalproject/views/widgets/our_button.dart';

class editaddress_controller extends StatefulWidget {
  final String documentId;
  final String firstname;
  final String surname;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String phone;

  editaddress_controller({
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
  _editaddressFormState createState() => _editaddressFormState();
}

class _editaddressFormState extends State<editaddress_controller> {
  late TextEditingController _firstnameController;
  late TextEditingController _surnameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalCodeController;

  @override
  void initState() {
    super.initState();
    _firstnameController = TextEditingController(text: widget.firstname);
    _surnameController = TextEditingController(text: widget.surname);
    _addressController = TextEditingController(text: widget.address);
    _cityController = TextEditingController(text: widget.city);
    _stateController = TextEditingController(text: widget.state);
    _postalCodeController = TextEditingController(text: widget.postalCode);
  }

void _showLoadingDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,  // User cannot dismiss the dialog by tapping outside.
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingAnimationWidget.inkDrop(
                color: Colors.blue,
                size: 50,
              ),
              SizedBox(height: 20),
              Text("Saving...", style: TextStyle(fontSize: 18)),
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
        title: "Edit Address".text.size(24).fontFamily(medium).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ourButton(
            onPress: () async {
            if (_firstnameController.text.isEmpty ||
                _surnameController.text.isEmpty ||
                _addressController.text.isEmpty ||
                _cityController.text.isEmpty ||
                _stateController.text.isEmpty ||
                _postalCodeController.text.isEmpty) {
              VxToast.show(context, msg: "All fields are required.");
              return;
            }
              _showLoadingDialog();
              Map<String, String> addressDetails = {
              'firstname': _firstnameController.text,
              'surname': _surnameController.text,
              'address': _addressController.text,
              'city': _cityController.text,
              'state': _stateController.text,
              'postalCode': _postalCodeController.text,
            };

            await Get.find<AuthController>().CreateAccountMethod(context, addressDetails);
            },
            color: primaryApp,
            textColor: whiteColor,
            title: "Save"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(
                label: "Firstname",
                controller: _firstnameController),
            customTextField(
                label: "Surname",
                controller: _surnameController),
            customTextField(
                label: "Address",
                controller: _addressController),
            customTextField(
                label: "City",
                controller: _cityController),
            customTextField(
                label: "State",
                controller: _stateController),
            customTextField(
                label: "Postal Code",
                controller: _postalCodeController),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

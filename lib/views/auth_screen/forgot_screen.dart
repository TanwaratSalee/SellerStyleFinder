// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:seller_finalproject/const/styles.dart';
import 'package:seller_finalproject/views/widgets/custom_textfield.dart';
import 'package:seller_finalproject/views/widgets/our_button.dart';

import '../../const/const.dart';

class ForgotScreen extends StatelessWidget {
  ForgotScreen({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
          // title: Text('Forgot Password?'),
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: const Text('Forgot Password?')
                  .text
                  .size(26)
                  .fontFamily(bold)
                  .color(greyDark2)
                  .make(),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                      'Don\'t worry! It occurs. Please enter the email address linked with your account.')
                  .text
                  .size(14)
                  .fontFamily(regular)
                  .color(greyDark2)
                  .make(),
            ),
            const SizedBox(height: 20),
            customTextField(
              label: 'Enter your email',
              controller: _emailController,
            ),
            const SizedBox(height: 20),
            ourButton(
              title: 'Send Code',
              color: primaryApp,
              textColor: whiteColor,
              onPress: () {
                _sendPasswordResetEmail(context);
                _showCustomDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      VxToast.show(context, msg: "Sent a reset password has been sent to ${_emailController.text}");
      VxToast.show(context,
          msg: "Reset password sent in your E-mail ${_emailController.text}");
    } catch (e) {
      VxToast.show(context, msg: "$e");
    }
  }
}

Future<void> _showCustomDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: whiteColor,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              Image.asset('assets/images/Finishpay.PNG'),
              const SizedBox(
                height: 40,
              ),
              const Text(
                'Check your email to reset your password!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Text(
              //   '1,400,000 Bath',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     color: Colors.blue,
              //     fontSize: 16,
              //   ),
              // ),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: primaryApp,
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Continue',
                style: TextStyle(fontFamily: regular),
              ),
            ),
          ),
        ],
      );
    },
  );
}

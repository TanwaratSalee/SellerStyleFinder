import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';

// Helper function to capitalize the first letter of each word
String capitalize(String input) {
  return input.split(' ').map((str) => str[0].toUpperCase() + str.substring(1)).join(' ');
}

Widget editTextField({
  String? title,
  String? label,
  TextEditingController? controller,
  bool isPass = false,
  bool readOnly = false,
  VoidCallback? onTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (label != null)
            Text(
              capitalize(label),
              style: const TextStyle(
                color: blackColor,
                fontSize: 16,
                fontFamily: medium,
              ),
            ),
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              obscureText: isPass,
              controller: controller,
              readOnly: readOnly,
              decoration: const InputDecoration(
                isDense: true,
                hintStyle: TextStyle(color: greyDark1),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: whiteColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: greyColor),
                ),
              ),
              onTap: onTap,
              textCapitalization: TextCapitalization.sentences, // This capitalizes the first letter of each sentence.
            ),
          ),
        ],
      ),
    ],
  );
}

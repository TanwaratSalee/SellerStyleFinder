import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';

Widget ourButton(
    {required String title,
    Color color = primaryApp,
    required VoidCallback onPress,
    Color textColor = whiteColor}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color, // Background color
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              minimumSize: const Size(double.infinity, 45),
          padding: const EdgeInsets.all(12.0)),
      onPressed: onPress,
      child: Text(
           title,).text.size(18).fontFamily(regular).color(whiteColor).make() // Pass textColor to Text
      );
}

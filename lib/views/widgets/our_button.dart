import 'package:seller_finalproject/const/const.dart';
import 'package:seller_finalproject/const/styles.dart';

Widget ourButton({
  VoidCallback? onPress,
  Color? color,
  Color? textColor,
  String? title,
  Color? borderColor, 
  double elevation = 2.0,
}) {
  return SizedBox(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderColor ?? Colors.transparent, width: 1), 
        ),
        minimumSize: const Size(double.infinity, 45),
      ),
      onPressed: onPress,
      child: Text(
        title ?? '',
        style: TextStyle(
          fontSize: 16,
          color: textColor ?? whiteColor,
          fontFamily: medium,
        ),
      ),
    ),
  );
}

import 'package:flutter/services.dart';
import 'package:seller_finalproject/const/const.dart';

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;

    // สตริงที่ได้จากการลบตัวอักษรทั้งหมดที่ไม่ใช่ตัวเลขออก
    final digitsOnly = newText.replaceAll(RegExp(r'\D'), '');

    // 3 หรือ 6 (i == 3 หรือ i == 6), จะเพิ่มขีดกลาง (-) 
    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 3 || i == 6) {
        formatted += '-';
      }
      formatted += digitsOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
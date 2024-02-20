import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool obscureText;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final String? errorText;
  final int? maxline;
  final bool? isNumbered;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.validator,
    this.errorText,
    this.maxline,
    this.isNumbered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        maxLines: maxline,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE23E3E)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE23E3E)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFE23E3E)),
          ),
          hintText: hintText,
          prefixIcon: prefixIcon,
        ),
        inputFormatters: isNumbered! ? [NumberedStepFormatter()] : null,
      ),
    );
  }
}

class NumberedStepFormatter extends TextInputFormatter {
  int stepNumber = 1;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedText = newValue.text;

    // Check if Enter key is pressed and there's no existing newline character
    if (oldValue.text.isEmpty ||
        !oldValue.text.endsWith('\n') &&
        newValue.text.endsWith('\n')) {
      formattedText = '$formattedText$stepNumber. ';
      stepNumber++;
    }

    // Check if the text is cleared
    if (oldValue.text.isNotEmpty && newValue.text.isEmpty) {
      // Reset stepNumber when text is cleared
      stepNumber = 1;
    }

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}








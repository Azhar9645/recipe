import 'package:flutter/material.dart';

class CustomWidget {
  static TextStyle heading1(BuildContext context) {
    return const TextStyle(
      fontSize: 26.0,
      fontWeight: FontWeight.w600,
      // Add any other styling properties as needed
    );
  }

  static TextStyle heading2(BuildContext context) {
    return const TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      // Add any other styling properties as needed
    );
  }

  static TextStyle heading3(BuildContext context) {
    return const TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      // Add any other styling properties as needed
    );
  }

  static TextStyle heading4(BuildContext context) {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      // Add any other styling properties as needed
    );
  }
  static TextStyle heading5(BuildContext context) {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      // Add any other styling properties as needed
    );
  }
  static TextStyle heading6(BuildContext context) {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      // Add any other styling properties as needed
    );
  }
  static TextStyle heading7(BuildContext context) {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white
      // Add any other styling properties as needed
    );
  }

  static ElevatedButton customButton(
      BuildContext context, String buttonText, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xFFE23E3E),
        padding:
            const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
        backgroundColor: Colors.white, // Set text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFFE23E3E), // Set outline color
          ),
        ),
      ),
      child: Text(
        buttonText,
        style: heading5(context),
      ),
    );
  }
}

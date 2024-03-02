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
    return  const TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      // Add any other styling properties as needed
    );
  }

  static TextStyle heading3(BuildContext context) {
    return  const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      // Add any other styling properties as needed
    );
  }

}

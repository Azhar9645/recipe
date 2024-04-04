import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();

  // Static method to show the loading dialog with a delay
  static void showLoadingDialog(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lottie/Animation - 1707395406065.json',
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(); // Placeholder widget is just a placeholder, replace it with your actual loading widget
  }
}

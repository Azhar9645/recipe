import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(); // Placeholder widget is just a placeholder, replace it with your actual loading widget
  }

  void showLoadingDialog(BuildContext context) {
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
  }
}

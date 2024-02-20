import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/components/bottomnavigationbar.dart';

class AddRecipe extends StatelessWidget {
  const AddRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CustomCurvedNavigationBar()));
        },
      )),
    );
  }
}

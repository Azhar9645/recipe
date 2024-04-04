import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/Hive/data_model.dart';
import 'package:recipe_app1/screens/Hive/function.dart';

class AddIngredientDialog {
  static void show(BuildContext context) {
    final TextEditingController _ingredientController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Ingredient'),
          content: TextField(
            controller: _ingredientController,
            decoration: InputDecoration(
              hintText: 'Enter ingredient name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
            TextButton(
              onPressed: () {
                final newIngredient = _ingredientController.text.trim();
                if (newIngredient.isNotEmpty) {
                  final extraIngredient = ExtraIngredients(ingredients: [
                    {'ingredient': newIngredient}
                  ]);
                  HiveService.addExtraIngredients(
                      DateTime.now().millisecondsSinceEpoch.toString(),
                      extraIngredient);
                  _ingredientController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

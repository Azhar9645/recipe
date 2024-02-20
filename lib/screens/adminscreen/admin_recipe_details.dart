import 'package:flutter/material.dart';

class RecipeDetailsPage extends StatelessWidget {
  final Map<String, dynamic> recipeData;

  RecipeDetailsPage({required this.recipeData});

  @override
  Widget build(BuildContext context) {
    // Extract all the details from recipeData
    String recipeName = recipeData['name'];
    String time = recipeData['time'];
    List<Map<String, dynamic>> ingredients = recipeData['ingredients'];
    String description = recipeData['description'];
    String direction = recipeData['direction'];

    return Scaffold(
      appBar: AppBar(
        title: Text(recipeName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display all the details here
            Text(
              'Name: $recipeName',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 18),
            Text(
              'Time: $time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 18),
            Text(
              'Description: $description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            // Display other details such as ingredients, direction, etc.
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RecipeListItem extends StatelessWidget {
  final String recipeName;
  final Map<dynamic, dynamic>? recipeData;

  RecipeListItem({required this.recipeName, required this.recipeData});

  @override
  Widget build(BuildContext context) {
    // Convert recipeData to Map<String, dynamic> if not null
    final Map<String, dynamic> recipe =
        recipeData?.cast<String, dynamic>() ?? {};

    // Get recipe details with conditional access
    final String? recipeDescription = recipe['description'] as String?;
    final String? recipeImageUrl = recipe['imageUrl'] as String?;

    // Customize how you want to display each recipe item in the list
    return GestureDetector(
      onTap: () {
        // Handle tapping on the recipe item if needed
      },
      child: Card(
        // Customize card appearance as per your UI requirements
        child: ListTile(
          title: Text(recipeName),
          subtitle: Text(recipeDescription ?? 'No description available'),
          leading: recipeImageUrl != null
              ? Image.network(recipeImageUrl)
              : Placeholder(), // Placeholder if no image available
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/components/widgets.dart';
import 'package:recipe_app1/screens/userscreen/recipe_details.dart';

class RecipeListItem extends StatelessWidget {
  final String recipeName;
  final String recipeTime;
  final Map<String, dynamic> recipeData;

  RecipeListItem({required this.recipeName, required this.recipeTime, required this.recipeData});

  @override
  Widget build(BuildContext context) {
    String photoBase64 = recipeData['photo'] ?? '';

    return ListTile(
      onTap: () {
        
      },
      contentPadding: const EdgeInsets.all(8),
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Image.memory(
          base64.decode(photoBase64),
          height: 60.0,
          width: 60.0,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        recipeName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12.0, color: Colors.grey),
      ),
      subtitle: Text(
        'Time: $recipeTime',
        style: TextStyle(fontSize: 12.0, color: Colors.grey),
      ),
      trailing: IconButton(
        icon: Icon(Icons.favorite),
        onPressed: () {
          // Handle favorite button tap
        },
        color: Colors.red, // Adjust the color as needed
      ),
    );
  }
}

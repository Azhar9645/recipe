import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/userscreen/recipe_details.dart';

class RecipeListItem extends StatelessWidget {
  final String recipeName;
  final String recipeTime;
  final Map<String, dynamic> recipeData;

  RecipeListItem(
      {required this.recipeName,
      required this.recipeTime,
      required this.recipeData});

  @override
  Widget build(BuildContext context) {
    String photoBase64 = recipeData['photo'] ?? '';

    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) =>
                    UserRecipeDetailsPage(recipeData: recipeData)));
      },
      contentPadding: const EdgeInsets.only(left: 18, right: 18),
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Image.memory(
          base64.decode(photoBase64),
          height: 70.0,
          width: 70.0,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        recipeName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 14.0, color: Colors.grey),
      ),
      subtitle: Text(
        'Time: $recipeTime',
        style: TextStyle(fontSize: 14.0, color: Colors.grey),
      ),
    );
  }
}

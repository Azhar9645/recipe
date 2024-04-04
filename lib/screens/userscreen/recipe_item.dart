import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:recipe_app1/screens/Hive/data_model.dart';
import 'package:recipe_app1/screens/Hive/function.dart';
import 'package:recipe_app1/screens/components/widgets.dart';
import 'package:recipe_app1/screens/userscreen/favoriteRecipe.dart';
import 'package:recipe_app1/screens/userscreen/recipe_details.dart';

class RecipeDetails extends StatefulWidget {
  final String recipeName;
  final Map<String, dynamic> recipeData;

  RecipeDetails({required this.recipeName, required this.recipeData});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  bool isFavorite = false;

 


 void _toggleFavorite() async {
  setState(() {
    isFavorite = !isFavorite;
  });

  final favRecipe = FavRecipe(
    recipeName: widget.recipeName,
    recipeData: widget.recipeData,
  );

  // Check if the recipe with the same ID already exists in the favorites list
  final existingRecipe = await HiveService.getFavRecipeById(widget.recipeData['id']);

  if (isFavorite && existingRecipe == null) {
    await HiveService.addFavRecipe(favRecipe);
  } else if (!isFavorite && existingRecipe != null) {
    await HiveService.removeFavRecipeById(widget.recipeData['id']);
  }
}




  @override
  Widget build(BuildContext context) {
    String photoBase64 = widget.recipeData['photo'] ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UserRecipeDetailsPage(recipeData: widget.recipeData),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
                child: Image.memory(
                  base64.decode(photoBase64),
                  height: 150.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFE23E3E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.recipeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomWidget.heading7(context),
                    ),
                  ),
                  IconButton(
                    icon: isFavorite
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_outline),
                    onPressed: _toggleFavorite,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

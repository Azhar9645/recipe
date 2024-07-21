import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/Hive/function.dart';
import 'package:recipe_app1/screens/Hive/data_model.dart';
import 'package:recipe_app1/screens/components/widgets.dart';
import 'package:recipe_app1/screens/userscreen/fav_details.dart';

class Wishlist extends StatefulWidget {
  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  List<FavRecipe> favoriteRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  Future<void> _loadFavoriteRecipes() async {
    final favRecipes = await HiveService.getFavRecipes();
    setState(() {
      favoriteRecipes = favRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saved Recipes',
              style: CustomWidget.heading2(context),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: favoriteRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = favoriteRecipes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavDetails(recipe: recipe),
                        ),
                      );
                    },
                    child: Container(
                      height: 80,
                      child: Card(
                        color: const Color(0xFFF1F1F1),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            recipe.recipeName,
                            style: CustomWidget.heading5(context),
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12), // Same as Card's borderRadius
                            child: Image.memory(
                              base64.decode(recipe.recipeData['photo'] ?? ''),
                              fit: BoxFit.cover,
                              width: 80,
                              height:
                                  80, // Set the height to the same value as width to make it a square
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: Color(0xFFE23E3E),
                            ),
                            onPressed: () async {
                              await HiveService.removeFavRecipeById(
                                recipe.recipeData['id'],
                              );
                              setState(() {
                                favoriteRecipes.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

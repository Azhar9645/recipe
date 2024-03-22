
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:recipe_app1/screens/Hive/data_model.dart';

class HiveService {
  static const String _recipeBoxName = 'recipe_db';
  static const String _favRecipeBoxName = 'fav_recipe';

  static Future<void> saveRecipe(UserRecipe recipe) async {
    final recipeBox = await Hive.openBox<UserRecipe>(_recipeBoxName);
    await recipeBox.add(recipe);
  }

  static Future<List<UserRecipe>> getAllRecipes() async {
    final recipeBox = await Hive.openBox<UserRecipe>(_recipeBoxName);
    return recipeBox.values.toList();
  }

  static ValueNotifier<List<UserRecipe>> watchAllRecipes() {
    final recipeBox = Hive.box<UserRecipe>(_recipeBoxName);
    final recipes = recipeBox.values.toList();
    final recipeListNotifier = ValueNotifier<List<UserRecipe>>(recipes);

    recipeBox.watch().listen((event) {
      final updatedRecipes = recipeBox.values.toList();
      recipeListNotifier.value = updatedRecipes;
    });

    return recipeListNotifier;
  }

  static Future<void> addFavRecipe(FavRecipe favRecipe) async {
    final box = await Hive.openBox<FavRecipe>(_favRecipeBoxName);
    await box.add(favRecipe);
  }

  static Future<List<FavRecipe>> getFavRecipes() async {
    final box = await Hive.openBox<FavRecipe>(_favRecipeBoxName);
    return box.values.toList();
  }

  static ValueNotifier<List<FavRecipe>> watchAllFavRecipes() {
    final favRecipeBox = Hive.box<FavRecipe>(_favRecipeBoxName);
    final favRecipes = favRecipeBox.values.toList();
    final favRecipeListNotifier = ValueNotifier<List<FavRecipe>>(favRecipes);

    favRecipeBox.watch().listen((event) {
      final updatedFavRecipes = favRecipeBox.values.toList();
      favRecipeListNotifier.value = updatedFavRecipes;
    });

    return favRecipeListNotifier;
  }

  // static Future<void> removeFavRecipe(String recipeName) async {
  //   final box = await Hive.openBox<FavRecipe>(_favRecipeBoxName);
  //   final favRecipes = box.values
  //       .where((favRecipe) => favRecipe.recipeName == recipeName)
  //       .toList();
  //   for (var favRecipe in favRecipes) {
  //     await box.delete(favRecipe.key);
  //   }
  // }

  static Future<void> removeFavRecipeById(String id) async {
  final box = await Hive.openBox<FavRecipe>(_favRecipeBoxName);
  await box.delete(id);
}

}

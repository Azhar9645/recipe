import 'package:hive/hive.dart';
import 'package:recipe_app1/screens/Hive/data_model.dart';
import 'package:flutter/foundation.dart';

class HiveService {
  static const String _recipeBoxName = 'recipe_db';
  static const String _favRecipeBoxName = 'fav_recipe';
  static const String _cartRecipeBoxName = 'cart_recipe';
  static const String _cartIngredientBoxName = 'ingredient_cart';

  static Future<void> saveRecipe(UserRecipe recipe) async {
    final recipeBox = await Hive.openBox<UserRecipe>(_recipeBoxName);
    await recipeBox.add(recipe);
  }

  static Future<void> updateRecipe(int index, UserRecipe updatedRecipe) async {
    final recipeBox = await Hive.openBox<UserRecipe>(_recipeBoxName);
    await recipeBox.putAt(index, updatedRecipe);
  }

  static Future<void> deleteRecipe(int index) async {
    final recipeBox = await Hive.openBox<UserRecipe>(_recipeBoxName);
    await recipeBox.deleteAt(index);
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

  static Future<void> addFavRecipe(FavRecipe recipe) async {
    final box = await Hive.openBox<FavRecipe>(_favRecipeBoxName);
    await box.put(recipe.recipeData['id'], recipe);
  }

  static Future<void> removeFavRecipeById(String id) async {
    final box = await Hive.openBox<FavRecipe>(_favRecipeBoxName);
    await box.delete(id);
  }

  static Future<FavRecipe?> getFavRecipeById(String id) async {
    final box = await Hive.openBox<FavRecipe>(_favRecipeBoxName);
    return box.get(id);
  }

  static Future<List<FavRecipe>> getFavRecipes() async {
    final box = await Hive.openBox<FavRecipe>(_favRecipeBoxName);
    return box.values.toList();
  }

  static Future<void> addToCart(CartIngredients recipe) async {
    final box = await Hive.openBox<CartIngredients>(_cartRecipeBoxName);
    await box.put(recipe.recipeData['id'], recipe);
  }

  static Future<void> removeCartRecipeById(String id) async {
    final box = await Hive.openBox<CartIngredients>(_cartRecipeBoxName);
    await box.delete(id);
  }

  static Future<CartIngredients?> getCartRecipeById(String id) async {
    final box = await Hive.openBox<CartIngredients>(_cartRecipeBoxName);
    return box.get(id);
  }

  static Future<List<CartIngredients>> getAllCartRecipes() async {
    final box = await Hive.openBox<CartIngredients>(_cartRecipeBoxName);
    return box.values.toList();
  }

  static ValueNotifier<List<CartIngredients>> watchAllCartRecipes() {
    final box = Hive.box<CartIngredients>(_cartRecipeBoxName);
    final cartItems = box.values.toList();
    final cartListNotifier = ValueNotifier<List<CartIngredients>>(cartItems);

    box.watch().listen((event) {
      final updatedCartItems = box.values.toList();
      cartListNotifier.value = updatedCartItems;
    });

    return cartListNotifier;
  }

  static Future<void> addExtraIngredients(String id, ExtraIngredients ingredients) async {
    final box = await Hive.openBox<ExtraIngredients>(_cartIngredientBoxName);
    await box.put(id, ingredients);
  }

  static Future<void> removeExtraIngredientsById(String id) async {
    final box = await Hive.openBox<ExtraIngredients>(_cartIngredientBoxName);
    await box.delete(id);
  }

  static Future<ExtraIngredients?> getExtraIngredientsById(String id) async {
    final box = await Hive.openBox<ExtraIngredients>(_cartIngredientBoxName);
    return box.get(id);
  }

  static Future<List<ExtraIngredients>> getAllExtraIngredients() async {
    final box = await Hive.openBox<ExtraIngredients>(_cartIngredientBoxName);
    return box.values.toList();
  }

  static ValueNotifier<List<ExtraIngredients>> watchAllExtraIngredients() {
    final box = Hive.box<ExtraIngredients>(_cartIngredientBoxName);
    final cartItems = box.values.toList();
    final ingredientListNotifier = ValueNotifier<List<ExtraIngredients>>(cartItems);

    box.watch().listen((event) {
      final updatedCartItems = box.values.toList();
      ingredientListNotifier.value = updatedCartItems;
    });

    return ingredientListNotifier;
  }
}

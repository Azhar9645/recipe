
class FavoriteRecipe {
  final String recipeName;
  final Map<String, dynamic> recipeData;

  FavoriteRecipe({required this.recipeName, required this.recipeData});

  factory FavoriteRecipe.fromJson(Map<String, dynamic> json) {
    return FavoriteRecipe(
      recipeName: json['recipeName'],
      recipeData: json['recipeData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeName': recipeName,
      'recipeData': recipeData,
    };
  }
}

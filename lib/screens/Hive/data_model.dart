import 'package:hive/hive.dart';
part 'data_model.g.dart';

@HiveType(typeId: 0)
class UserRecipe {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final List<Map<String, String>> ingredients;

  @HiveField(3)
  final String direction;

  @HiveField(4)
  final String time;

  @HiveField(5)
  final String imagePath;

  UserRecipe({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.direction,
    required this.time,
    required this.imagePath,
  });

  get instructions => null;
}

@HiveType(typeId: 1)
class FavRecipe extends HiveObject {
  @HiveField(0)
  late String recipeName;

  @HiveField(1)
  late Map<String, dynamic> recipeData;

  FavRecipe({required this.recipeName, required this.recipeData});
}

@HiveType(typeId: 2)
class CartIngredients extends HiveObject {
  @HiveField(0)
  late String recipeName;

  @HiveField(1)
  late Map<String, dynamic> recipeData;

  CartIngredients({
    required this.recipeName,
    required this.recipeData,
  });
}

@HiveType(typeId: 3)
class ExtraIngredients extends HiveObject {
  @HiveField(0)
  final List<Map<String, String>> ingredients;

  ExtraIngredients({
    required this.ingredients,
  });
}

@HiveType(typeId: 4)
class EditProfile extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late int phone;

  @HiveField(3)
  late String profilePhotoPath;

  EditProfile({
    required this.name,
    required this.description,
    required this.phone,
    required this.profilePhotoPath,
  });
}

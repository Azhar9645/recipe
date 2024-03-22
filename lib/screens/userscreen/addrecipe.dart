import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app1/screens/Hive/function.dart';
import 'package:recipe_app1/screens/components/bottomnavigationbar.dart';
import 'package:recipe_app1/screens/components/mybutton.dart';
import 'package:recipe_app1/screens/components/mytextfield.dart';

import '../Hive/data_model.dart';

class AddRecipe extends StatefulWidget {
  final recipe;
  AddRecipe({super.key, this.recipe});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  File? photo;
  List<Widget> ingredientRows = [];

  List<Map<String, TextEditingController>> ingredientsList = [];
  List<Map<String, String>> ingredientsWithQuantities = [];

  final recipeNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final ingredientController = TextEditingController();
  final quantityController = TextEditingController();
  final directionController = TextEditingController();
  final timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomCurvedNavigationBar()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter Recipe Details',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () => _getImage(context: context),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE23E3E),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: photo != null
                        ? Image.file(photo!, fit: BoxFit.cover)
                        : const Center(
                            child: Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Color(0xFFC1C1C1),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Name',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              MyTextfield(
                maxline: 1,
                controller: recipeNameController,
                hintText: '',
              ),
              const SizedBox(height: 8),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
              ),
              MyTextfield(
                controller: descriptionController,
                hintText: '',
                maxline: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        ingredientsList.add({
                          'ingredient': TextEditingController(),
                          'quantity': TextEditingController(),
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 30,
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: ingredientsList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: MyTextfield(
                            controller: ingredientsList[index]['ingredient']!,
                            hintText: 'Item name',
                            maxline: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MyTextfield(
                            controller: ingredientsList[index]['quantity']!,
                            hintText: 'Quantity',
                            maxline: 1,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              ingredientsList.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Text(
                'Direction',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
              ),
              MyTextfield(
                controller: directionController,
                hintText: 'Step by step',
                maxline: null,
                isNumbered: true,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Text(
                    'Time',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyTextfield(
                      controller: timeController,
                      hintText: 'hh:mm',
                      maxline: 1,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              MyButton(
                text: 'Save my recipe',
                onPressed: () async {
                  // Create a list to hold the ingredients with their quantities
                  List<Map<String, String>> ingredientsWithQuantities = [];

                  // Iterate through each ingredient in the ingredientsList and add it to the list
                  for (var ingredient in ingredientsList) {
                    // Extract the name and quantity from the text controllers
                    String ingredientName = ingredient['ingredient']!.text;
                    String ingredientQuantity = ingredient['quantity']!.text;

                    // Create a map to hold the ingredient name and quantity
                    Map<String, String> ingredientMap = {
                      'name': ingredientName,
                      'quantity': ingredientQuantity,
                    };

                    // Add the ingredient map to the list
                    ingredientsWithQuantities.add(ingredientMap);
                  }

                  // Create a UserRecipe object with the entered details
                  UserRecipe recipe = UserRecipe(
                    name: recipeNameController.text,
                    description: descriptionController.text,
                    ingredients: ingredientsWithQuantities,
                    direction: directionController.text,
                    time: timeController.text,
                    imagePath: photo != null
                        ? photo!.path
                        : '', // Path to the image if available
                  );

                  // Print the recipe data before saving
                  print('Recipe Data Before Saving:');
                  print('Name: ${recipe.name}');
                  print('Description: ${recipe.description}');
                  print('Ingredients: ${recipe.ingredients}');
                  print('Direction: ${recipe.direction}');
                  print('Time: ${recipe.time}');
                  print('Image Path: ${recipe.imagePath}');

                  // Save the recipe
                  await HiveService.saveRecipe(recipe);

                  // Print the recipe data after saving
                  print('Recipe Data After Saving:');
                  print('Name: ${recipe.name}');
                  print('Description: ${recipe.description}');
                  print('Ingredients: ${recipe.ingredients}');
                  print('Direction: ${recipe.direction}');
                  print('Time: ${recipe.time}');
                  print('Image Path: ${recipe.imagePath}');

                  // Navigate to another screen (for example, RecipeListScreen)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomCurvedNavigationBar()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImage({required BuildContext context}) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    print("Image Path: ${pickedFile.path}");

    setState(() {
      photo = File(pickedFile.path);
    });
  }
}

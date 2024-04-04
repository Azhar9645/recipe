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
  final int? recipeIndex;
  AddRecipe({super.key, this.recipe, this.recipeIndex});

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

  bool get isEditMode => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      // Populate the fields with existing recipe details
      recipeNameController.text = widget.recipe.name;
      descriptionController.text = widget.recipe.description;
      directionController.text = widget.recipe.direction;
      timeController.text = widget.recipe.time;
      // If there are ingredients, populate them as well
      if (widget.recipe.ingredients != null) {
        for (var ingredient in widget.recipe.ingredients!) {
          TextEditingController ingredientController = TextEditingController();
          TextEditingController quantityController = TextEditingController();
          ingredientController.text = ingredient['name'] ?? '';
          quantityController.text = ingredient['quantity'] ?? '';
          ingredientsList.add({
            'ingredient': ingredientController,
            'quantity': quantityController,
          });
        }
      }
      // If the recipe contains an image path, display the image
      if (widget.recipe != null &&
          widget.recipe.imagePath != null &&
          widget.recipe.imagePath.isNotEmpty) {
        setState(() {
          photo = File(widget.recipe.imagePath);
        });
      }
    }
  }

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
                text: widget.recipe != null ? 'Update' : 'Save my recipe',
                onPressed: _saveOrUpdateRecipe,
              ),
            ],
          ),
        ),
      ),
    );
  }

 Future<void> _saveOrUpdateRecipe() async {
  List<Map<String, String>> ingredientsWithQuantities = [];

  for (var ingredient in ingredientsList) {
    String ingredientName = ingredient['ingredient']!.text;
    String ingredientQuantity = ingredient['quantity']!.text;

    Map<String, String> ingredientMap = {
      'name': ingredientName,
      'quantity': ingredientQuantity,
    };

    ingredientsWithQuantities.add(ingredientMap);
  }

  UserRecipe recipe = UserRecipe(
    name: recipeNameController.text,
    description: descriptionController.text,
    ingredients: ingredientsWithQuantities,
    direction: directionController.text,
    time: timeController.text,
    imagePath: photo != null ? photo!.path : '',
  );

  if (widget.recipe != null) {
    // If recipe is not null, then it means we are updating an existing recipe
    // In this case, you need to handle the index externally
    if (widget.recipeIndex != null) {
      await HiveService.updateRecipe(widget.recipeIndex!, recipe);
    } else {
      print("Error: Recipe index is null.");
    }
  } else {
    // If recipe is null, then it means we are saving a new recipe
    await HiveService.saveRecipe(recipe);
  }

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CustomCurvedNavigationBar()),
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

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/adminscreen/admin_recipe_details.dart';
import 'package:recipe_app1/screens/components/normalbutton.dart';
import 'package:recipe_app1/screens/services/firestore.dart';

class CategoryPage extends StatelessWidget {
  final String categoryName;

  final List<Map<String, dynamic>?> recipes;
  CategoryPage({required this.categoryName, required this.recipes});

  // Change the type to allow null
  final FirestoreServices firestoreServices = FirestoreServices();

  @override
  Widget build(BuildContext context) {
    print('Number of recipes: ${recipes.length}'); // Debug print
    String selectedCategory = categoryName;

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: recipes.isEmpty
            ? Center(
                child: Text('No recipes found for $categoryName'),
              )
            : ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic>? recipe = recipes[index]; // Allow null
                  if (recipe == null) {
                    return const SizedBox.shrink(); // or handle null case
                  }
                  String recipeName = recipe['name'] ?? 'Unnamed Recipe';
                  String time = recipe['time'] ?? 'N/A';
                  String base64Image = recipe['photo'] ?? '';

                  print('Recipe $index: $recipeName'); // Debug print

                  return GestureDetector(
                    onTap: () {
                      // Navigate to RecipeDetailsPage and pass the full recipe data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetailsPage(recipeData: recipe,selectedCategory:categoryName),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      child: Card(
                        color: const Color(0xFFF1F1F1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: base64Image.isNotEmpty
                                      ? Image.memory(
                                          base64Decode(base64Image),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.image,
                                          size: 50,
                                          color: Color(0xFFC1C1C1),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      recipeName,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 18),
                                    Text(
                                      'Time: $time',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: IconButton(
                                  onPressed: () async {
                                    final docID = recipe['id'];
                                    print('Document ID to delete: $docID');
                                    if (docID != null) {
                                      await showDeleteConfirmationDialog(
                                          context, selectedCategory, docID);
                                      print(
                                          'Selected Category: $selectedCategory');
                                    } else {
                                      print(
                                          "Document ID is null. Unable to delete recipe.");
                                      print("Recipe Object: $recipe");
                                    }
                                  },
                                  icon: Icon(Icons.delete_outline),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  showDeleteConfirmationDialog(
      BuildContext context, String selectedCategory, String docID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text(
          'You want to delete the recipe with ID "$docID" from category "$selectedCategory"?',
        ),
        actions: [
          Column(
            children: [
              NormalButton(
                text: 'Yes',
                onPressed: () async {
                  print(
                      "Before calling deleteRecipeById. Selected category: $selectedCategory");

                  // Call the delete function with proper error handling
                  try {
                    await firestoreServices.deleteRecipe(
                        selectedCategory, docID);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Recipe deleted successfully!'),
                      ),
                    );
                    print(
                        "After calling deleteRecipeById. Selected category: $selectedCategory");
                  } catch (error) {
                    print("Error deleting recipe: $error");
                    // Optionally, display an error message to the user
                  }

                  Navigator.pop(context); // Close the dialog
                },
              ),
              const SizedBox(height: 10),
              NormalButton(
                text: 'No',
                onPressed: () => Navigator.pop(context), // Close the dialog
              ),
            ],
          ),
        ],
      ),
    );
  }
}

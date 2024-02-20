import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/adminscreen/admin_recipe_details.dart';

class CategoryPage extends StatelessWidget {
  final String categoryName;
  final List<Map<String, dynamic>> recipes;

  CategoryPage({required this.categoryName, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            String recipeName = recipes[index]['name'];
            String time = recipes[index]['time'];
            String base64Image = recipes[index]['photo'];

            return GestureDetector(
              onTap: () {
                // Navigate to RecipeDetailsPage and pass the full recipe data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RecipeDetailsPage(recipeData: recipes[index]),
                  ),
                );
              },
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
                          child: base64Image != null
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
                            ),
                            SizedBox(height: 18),
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
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

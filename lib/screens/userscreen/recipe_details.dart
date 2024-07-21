import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/Hive/data_model.dart';
import 'package:recipe_app1/screens/Hive/function.dart';
import 'package:recipe_app1/screens/components/mybutton.dart';
import 'package:recipe_app1/screens/components/widgets.dart';

class UserRecipeDetailsPage extends StatelessWidget {
  final Map<String, dynamic> recipeData;

  UserRecipeDetailsPage({required this.recipeData});

  @override
  Widget build(BuildContext context) {
    String recipeName = recipeData['name'] ?? '';
    String time = recipeData['time'] ?? '';
    List<dynamic>? ingredientsData = recipeData['ingredients'];
    List<Map<String, dynamic>> ingredients = ingredientsData != null
        ? List<Map<String, dynamic>>.from(ingredientsData)
        : [];
    String description = recipeData['description'] ?? '';
    String direction = recipeData['direction'] ?? '';
    String photoBase64 = recipeData['photo'] ?? '';

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 325,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.memory(
                  base64.decode(photoBase64),
                  fit: BoxFit.cover,
                ),
              ),
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: DefaultTabController(
                length: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$recipeName',
                        style: CustomWidget.heading2(context),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Time: $time',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$description',
                        style: CustomWidget.heading6(context),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        child: const TabBar(
                          tabs: [
                            Tab(
                              child: Text(
                                'Ingredients',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Step by Step',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Color(0xFFE23E3E),
                          indicatorWeight: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 400,
                        child: TabBarView(
                          children: [
                            if (ingredients.isNotEmpty) ...[
                              ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: ingredients.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final ingredient = ingredients[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 7),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          ingredient['ingredient'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing: Text(
                                          ingredient['quantity'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                            if (direction.isNotEmpty) ...[
                              ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  Text(
                                    '$direction',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      MyButton(
                          text: 'Shop Ingredients',
                          onPressed: () {
                            _shopIngredients(recipeData);
                          })
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shopIngredients(Map<String, dynamic> recipeData) async {
  // Extract the recipeName from recipeData
  String recipeName = recipeData['name'] ?? '';
  print('Recipe Name: $recipeName');

  // Create a CartIngredients instance with both recipeName and recipeData
  CartIngredients recipe =
      CartIngredients(recipeName: recipeName, recipeData: recipeData);

  // Call the addToCart function from HiveService
  await HiveService.addToCart(recipe);
}

}

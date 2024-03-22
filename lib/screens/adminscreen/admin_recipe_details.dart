import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/adminscreen/adminaddrecipe.dart';
import 'package:recipe_app1/screens/components/widgets.dart';

class RecipeDetailsPage extends StatelessWidget {
  final Map<String, dynamic> recipeData;
  final String selectedCategory;

  RecipeDetailsPage({required this.recipeData, required this.selectedCategory});

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$recipeName',
                            style: CustomWidget.heading2(context),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminRecipeAdd(
                                      recipeData: recipeData,
                                      selectedCategory: selectedCategory,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit))
                        ],
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
                        child: TabBar(
                          tabs: [
                            Tab(text: 'Ingredients'),
                            Tab(text: 'Step by Step'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 400,
                        child: TabBarView(
                          children: [
                            if (ingredients.isNotEmpty) ...[
                              ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: ingredients.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final ingredient = ingredients[index];
                                  return ListTile(
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
                                  );
                                },
                              ),
                            ],
                            if (direction.isNotEmpty) ...[
                              ListView(
                                physics: AlwaysScrollableScrollPhysics(),
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
}

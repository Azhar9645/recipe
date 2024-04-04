import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/components/mybutton.dart';
import 'package:recipe_app1/screens/Hive/data_model.dart';

class FavDetails extends StatelessWidget {
  final FavRecipe recipe;

  const FavDetails({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              expandedHeight: 325,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.memory(
                  base64.decode(recipe.recipeData['photo'] ?? ''),
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
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
                        recipe.recipeName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        recipe.recipeData['time'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        recipe.recipeData['description'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
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
                            if (recipe.recipeData['ingredients'] != null) ...[
                              ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: (recipe.recipeData['ingredients']
                                        as List<dynamic>)
                                    .length,
                                itemBuilder: (BuildContext context, int index) {
                                  final ingredient =
                                      (recipe.recipeData['ingredients']
                                          as List<dynamic>)[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 7),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          ingredient['ingredient'].toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing: Text(
                                          ingredient['quantity'].toString(),
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
                            if (recipe.recipeData['direction'] != null) ...[
                              ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  Text(
                                    recipe.recipeData['direction'].toString(),
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
                      MyButton(text: 'Shop Ingredients', onPressed: () {})
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

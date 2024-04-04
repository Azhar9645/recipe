import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/components/mybutton.dart';
import 'package:recipe_app1/screens/components/widgets.dart';
import 'package:recipe_app1/screens/userscreen/addrecipe.dart';
import '../Hive/data_model.dart';

class UserAddRecipe extends StatelessWidget {
  final UserRecipe recipe;
  final int recipeIndex;

  const UserAddRecipe({Key? key, required this.recipe,required this.recipeIndex}) : super(key: key);

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
                background: recipe.imagePath.isNotEmpty
                    ? Image.file(
                        File(recipe.imagePath),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/placeholder_image.png',
                        fit: BoxFit.cover,
                      ), // You can replace Container() with a placeholder widget
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            recipe.name,
                            style: CustomWidget.heading2(context),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddRecipe(recipe: recipe,recipeIndex: recipeIndex,),
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        recipe.time,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        recipe.description,
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
                            if (recipe.ingredients.isNotEmpty) ...[
                              ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: recipe.ingredients.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final ingredient = recipe.ingredients[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 7),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          ingredient['ingredient']
                                              .toString(), // Convert to string if necessary
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing: Text(
                                          ingredient['quantity']
                                              .toString(), // Convert to string if necessary
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
                            if (recipe.direction.isNotEmpty) ...[
                              ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  Text(
                                    recipe.direction,
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

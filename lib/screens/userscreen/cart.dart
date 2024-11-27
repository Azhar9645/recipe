import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/Hive/data_model.dart';
import 'package:recipe_app1/screens/Hive/function.dart';
import 'package:recipe_app1/screens/components/widgets.dart';

class Cart extends StatefulWidget {
  final String? recipeName;
  final List<Map<String, dynamic>>? ingredients;

  Cart({Key? key, this.recipeName, this.ingredients}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late List<Map<String, dynamic>> _ingredients;

  @override
  void initState() {
    super.initState();
    _ingredients = widget.ingredients ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final cartListNotifier = HiveService.watchAllCartRecipes();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Shopping List',
          style: CustomWidget.heading2(context),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.add_circle_outline_rounded,
        //       size: 30,
        //     ),
        //     onPressed: () {
        //       AddIngredientDialog.show(context);
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<List<CartIngredients>>(
          valueListenable: cartListNotifier,
          builder: (context, cartIngredients, _) {
            if (cartIngredients.isEmpty) {
              return Center(child: Text('No ingredients added to cart'));
            }

            return ListView.separated(
              itemCount: cartIngredients.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final ingredient = cartIngredients[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      child: Card(
                        color: const Color(0xFFF1F1F1),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(8),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              base64
                                  .decode(ingredient.recipeData['photo'] ?? ''),
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                            ),
                          ),
                          title: Text(
                            ingredient.recipeName,
                            style: CustomWidget.heading5(context),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              HiveService.removeCartRecipeById(
                                  ingredient.recipeData['id']);
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Ingredients',
                        style: CustomWidget.heading32(context),
                      ),
                    ),
                    Column(
                      children: List.generate(
                        (ingredient.recipeData['ingredients'] as List).length,
                        (index) {
                          final ingredientData =
                              ingredient.recipeData['ingredients'][index];
                          return Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 1),
                                title: Text(
                                  '${ingredientData['ingredient']} (${ingredientData['quantity']})',
                                ),
                                trailing: Checkbox(
                                  value: ingredientData['checked'] ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      ingredientData['checked'] = value;
                                    });
                                  },
                                  activeColor: Color(0xFFE23E3E),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

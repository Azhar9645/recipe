import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/components/widgets.dart';
import 'package:recipe_app1/screens/services/firestore.dart';
import 'package:recipe_app1/screens/userscreen/recipe_item.dart';
import 'package:recipe_app1/screens/userscreen/recipelist_search.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final searchController = TextEditingController();
  final FirestoreServices firestoreServices = FirestoreServices();
  int selectedIndex = 0; // Track the index of the clicked item
  late String selectedCategory = 'All'; // Default value
  List<Map<String, dynamic>> allRecipesList = [];
  List<Map<String, dynamic>> filteredRecipesList = [];
  final FocusNode _focusNode = FocusNode();

  bool isSearching = false;

  void _closeSearch() {
    setState(() {
      isSearching = false;
      searchController.clear();
      filteredRecipesList = allRecipesList;
      _focusNode.unfocus();
    });
  }

  @override
  void initState() {
    super.initState();
    firestoreServices
        .getRecipeStream('All')
        .listen((List<Map<String, dynamic>> recipes) {
      setState(() {
        allRecipesList = recipes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _closeSearch,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find best recipes',
                          style: CustomWidget.heading1(context),
                        ),
                        Text(
                          'for cooking',
                          style: CustomWidget.heading1(context),
                        ),
                        const SizedBox(height: 25),
                        TextField(
                          focusNode: _focusNode,
                          onTap: () {
                            setState(() {
                              isSearching = true;
                              filteredRecipesList = allRecipesList;
                            });
                          },
                          onChanged: (value) {
                            // Filter recipes based on the search text
                            List<Map<String, dynamic>> filteredList =
                                allRecipesList
                                    .where((recipe) => recipe['name']
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();

                            setState(() {
                              filteredRecipesList = filteredList;
                            });
                          },
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search recipes',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10.0),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'Popular category',
                          style: CustomWidget.heading2(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: firestoreServices.getCategoryStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                return SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (context, index) => SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            selectedCategory =
                                snapshot.data!.docs[index]['category'];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          decoration: BoxDecoration(
                            color: index == selectedIndex
                                ? Color(0xFFE23E3E)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              snapshot.data!.docs[index]['category'],
                              style: TextStyle(
                                color: index == selectedIndex
                                    ? Colors.white
                                    : Color(0xFFE23E3E),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            Expanded(
              child: isSearching
                  ? ListView.builder(
                      itemCount: filteredRecipesList.length,
                      itemBuilder: (context, index) {
                        final recipeData = filteredRecipesList[index];
                        final recipeName = recipeData['name'] ?? 'Unknown';

                        return RecipeListItem(
                          recipeData: recipeData,
                          recipeName: '$recipeName',
                          recipeTime: recipeData['time'] ?? 'Unknown',
                        );
                      },
                    )
                  : selectedCategory == 'All' && allRecipesList.isNotEmpty
                      ? CarouselSlider.builder(
                          itemCount: allRecipesList.length,
                          options: CarouselOptions(
                            height: 500,
                            aspectRatio: 1 / 1.4,
                            viewportFraction: 0.75,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                          itemBuilder: (context, index, realIndex) {
                            final recipeData = allRecipesList[index];
                            final recipeName = recipeData['name'] ?? 'Unknown';

                            return RecipeDetails(
                              recipeData: recipeData,
                              recipeName: '$recipeName',
                            );
                          },
                        )
                      : StreamBuilder<List<Map<String, dynamic>>>(
                          stream: firestoreServices
                              .getRecipeStream(selectedCategory),
                          builder: (context,
                              AsyncSnapshot<List<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text(
                                  'No recipes found for the selected category.');
                            }

                            print('Retrieved Data: ${snapshot.data}');

                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                  childAspectRatio: 0.9,
                                ),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final recipeData = snapshot.data![index];
                                  final recipeName =
                                      recipeData['name'] ?? 'Unknown';

                                  return RecipeDetails(
                                    recipeData: recipeData,
                                    recipeName: '$recipeName',
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

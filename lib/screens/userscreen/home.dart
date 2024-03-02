import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:recipe_app1/screens/components/widgets.dart';
import 'package:recipe_app1/screens/services/firestore.dart';
import 'package:recipe_app1/screens/userscreen/customcarousel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final searchController = TextEditingController();
  final FirestoreServices firestoreServices = FirestoreServices();
  bool isClicked = false;
  int selectedIndex = -1; // Track the index of the clicked item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                        const SizedBox(height: 30),
                        TextField(
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
                        const SizedBox(height: 30),
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
            // Custom TabBarView
            StreamBuilder<QuerySnapshot>(
              stream: firestoreServices.getCategoryStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No data available');
                } else {
                  return SizedBox(
                    height: 300, // Adjust the height as needed
                    child: DefaultTabController(
                      length: snapshot.data!.docs.length,
                      child: Column(
                        children: [
                          TabBar(
                            isScrollable: true,
                            tabs: List.generate(
                              snapshot.data!.docs.length,
                              (index) {
                                var categoryData = snapshot.data!.docs[index]
                                    .data() as Map<String, dynamic>;
                                return Tab(
                                  child: Text(categoryData['category']),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: List.generate(
                                snapshot.data!.docs.length,
                                (index) {
                                  var categoryData = snapshot.data!.docs[index]
                                      .data() as Map<String, dynamic>;
                                  // Fetch and display recipes associated with the category
                                  return StreamBuilder<QuerySnapshot>(
                                    stream: firestoreServices.getRecipesStream(
                                        categoryData['category']),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      print('StreamBuilder Rebuilt');
                                      print(
                                          'Snapshot Data: ${snapshot.data?.docs.map((doc) => doc.data())}');
                                      print(
                                          'Document Changes: ${snapshot.data?.docChanges}');
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (!snapshot.hasData ||
                                          snapshot.data == null) {
                                        print('No data available yet.');
                                        return Text('No data available yet.');
                                      } else {
                                        List<Map<String, dynamic>> recipes =
                                            snapshot.data!.docs.map(
                                                (DocumentSnapshot document) {
                                          Map<String, dynamic> recipeData =
                                              document.data()
                                                  as Map<String, dynamic>;
                                          recipeData['id'] = document.id;
                                          return recipeData;
                                        }).toList();

                                        if (recipes.isEmpty) {
                                          print(
                                              'No recipes found for ${categoryData['category']}');
                                          return Text(
                                              'No recipes found for ${categoryData['category']}');
                                        }

                                        // Print recipe details for debugging
                                        print('Recipe details:');
                                        recipes.forEach((recipe) {
                                          print(
                                              'Recipe Name: ${recipe['name']}');
                                          // Add more fields as needed for debugging
                                        });

                                        // Display recipes in a ListView or any other UI component
                                        return ListView.builder(
                                          itemCount: recipes.length,
                                          itemBuilder: (context, recipeIndex) {
                                            var recipe = recipes[recipeIndex];
                                            return ListTile(
                                              title: Text(recipe['name']),
                                              // Add more details if needed
                                            );
                                          },
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 350,
              child: CarouselSlider(
                items: const [
                  CustomCarouselItem(
                    imagePath:
                        'assets/recipeimages/Spicy-Beef-Curry-square.jpg',
                    title: 'Beef curry',
                  ),
                  CustomCarouselItem(
                    imagePath:
                        'assets/recipeimages/shreyak-singh-0j4bisyPo3M-unsplash.jpg',
                    title: 'Biriyani',
                  ),
                  CustomCarouselItem(
                    imagePath: 'assets/recipeimages/fish-curry.jpg',
                    title: 'Fish curry',
                  ),
                  // Add more carousel items as needed
                ],
                options: CarouselOptions(
                  height: 500,
                  aspectRatio: 1 / 1.4,
                  viewportFraction: 0.6,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    // Add any logic you need when the carousel page changes
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

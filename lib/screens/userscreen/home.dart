import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
                      const Text(
                        'Find best recipes',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'for cooking',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w500),
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
                      const Text(
                        'Popular category',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 45, // Adjust the height as needed
            child: StreamBuilder(
              stream: firestoreServices.getCategoryStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: 15), // Adjust spacing
                  itemBuilder: (context, index) {
                    var categoryData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    bool isClicked = index == selectedIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: isClicked
                              ? Color(0xFFE23E3E)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            categoryData['category'],
                            style: TextStyle(
                              color:
                                  isClicked ? Colors.white : Color(0xFFE23E3E),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 350,
            child: CarouselSlider(
              items: const [
                CustomCarouselItem(
                  imagePath:
                      'assets/recipeimages/Spicy-Beef-Curry-square.jpg', // Replace with your image path
                  title: 'Beef curry',
                ),
                CustomCarouselItem(
                  imagePath:
                      'assets/recipeimages/shreyak-singh-0j4bisyPo3M-unsplash.jpg', // Replace with your image path
                  title: 'Biriyani',
                ),
                CustomCarouselItem(
                  imagePath:
                      'assets/recipeimages/fish-curry.jpg', // Replace with your image path
                  title: 'Fish curry',
                ),
                // Add more carousel items as needed
              ],
              options: CarouselOptions(
                height: 500,

                aspectRatio:
                    1 / 1.4, // Set aspectRatio for more height than width
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
    );
  }
}

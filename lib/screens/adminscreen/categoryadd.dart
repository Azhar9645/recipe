import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/adminscreen/categorypage.dart';
import 'package:recipe_app1/screens/components/mybutton.dart';
import 'package:recipe_app1/screens/components/mytextfield.dart';
import 'package:recipe_app1/screens/components/normalbutton.dart';
import 'package:recipe_app1/screens/services/firestore.dart';

class CategoryAdd extends StatefulWidget {
  CategoryAdd({Key? key}) : super(key: key);

  @override
  _CategoryAddState createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final FirestoreServices firestoreServices = FirestoreServices();
  final categoryController = TextEditingController();
  final noController = TextEditingController();

  String selectedCategory = "";

  void showDeleteConfirmationDialog(String docID, String categoryName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure??'),
        content: Text('You want to delete  "$categoryName"?'),
        actions: [
          Column(
            children: [
              NormalButton(
                text: 'Yes',
                onPressed: () async {
                  // Perform the deletion if the user confirms
                  await firestoreServices.deleteCategory(docID);

                  // Show a Snackbar indicating successful deletion
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Category deleted successfully!'),
                    ),
                  );

                  Navigator.pop(context); // Close the dialog
                },
              ),
              SizedBox(
                height: 10,
              ),
              NormalButton(
                text: 'No',
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void categorybox({String? docID, String? initialValue}) {
    categoryController.text = initialValue ?? '';

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Unfocus the keyboard when tapping outside the TextField
          FocusScope.of(context).unfocus();
        },
        child: AlertDialog(
          content: MyTextfield(
            controller: categoryController,
            hintText: 'Category',
          ),
          actions: [
            MyButton(
              text: 'Add',
              onPressed: () async {
                String newCategory = categoryController.text.trim();

                // Check if the category is not null and not empty
                if (newCategory.isNotEmpty) {
                  bool exists = await categoryExists(newCategory);

                  if (exists) {
                    // Show a Snackbar if the category already exists
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Category already exists!'),
                      ),
                    );
                  } else {
                    // Add or update category based on docID
                    if (docID == null) {
                      firestoreServices.addCategory(newCategory);
                      // Show a Snackbar indicating successful addition
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Category added successfully!'),
                        ),
                      );
                    } else {
                      firestoreServices.updateCategory(docID, newCategory);
                      // Show a Snackbar indicating successful update
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Category updated successfully!'),
                        ),
                      );
                    }

                    // Clear the text controller
                    categoryController.clear();

                    // Close the box
                    Navigator.pop(context);
                  }
                } else {
                  // Show an error message or handle accordingly for empty category
                  print('Category cannot be empty!');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> categoryExists(String category) async {
    try {
      // Reference to the 'categories' collection in Firestore
      CollectionReference categories =
          FirebaseFirestore.instance.collection('category');

      // Query to check if the category already exists (case-insensitive and whitespace-insensitive)
      QuerySnapshot querySnapshot = await categories.get();

      // Iterate through the documents to find a matching category
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        String existingCategory =
            doc['category'].toString().toLowerCase().trim();
        if (existingCategory == category.toLowerCase().trim()) {
          // Category found
          return true;
        }
      }

      // If no matching category is found
      return false;
    } catch (e) {
      // Handle errors, log them, or return false as a default
      print('Error checking category existence: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          'Popular categories',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              categorybox();
            },
            icon: const Icon(
              Icons.add_circle_outline,
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestoreServices.getCategoryStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List categorylist = snapshot.data!.docs;
              return ListView.builder(
                itemCount: categorylist.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = categorylist[index];
                  String docID = document.id;
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String categoryText = data['category'] ?? "defaultCategory";

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFE23E3E),
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      child: ListTile(
                        onTap: () async {
                          // Store the required data before entering the asynchronous block
                          String selectedCategoryText = categoryText;

                          // Fetch recipe data for the selected category
                          List<Map<String, dynamic>>? recipeDataList =
                              await firestoreServices
                                  .getRecipeData(selectedCategoryText);

                          // Check if recipeDataList is not null and not empty
                          if (recipeDataList != null &&
                              recipeDataList.isNotEmpty) {
                            // Capture the context after the asynchronous block
                            BuildContext contextAfterAsync = context;

                            Navigator.push(
                              contextAfterAsync,
                              MaterialPageRoute(
                                builder: (context) => CategoryPage(
                                  categoryName: selectedCategoryText,
                                  recipes: recipeDataList,
                                ),
                              ),
                            );
                          } else {
                            // Handle the case where no recipes are found
                            print(
                                "No recipes found for category: $selectedCategoryText");
                          }
                        },
                        title: Text(categoryText.toUpperCase()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => categorybox(
                                docID: docID,
                                initialValue: categoryText,
                              ),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                            IconButton(
                              onPressed: () {
                                showDeleteConfirmationDialog(
                                    docID, categoryText);
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text('No category..');
            }
          },
        ),
      ),
    );
  }
}

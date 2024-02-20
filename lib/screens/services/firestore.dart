import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference category =
      FirebaseFirestore.instance.collection('category');

  final CollectionReference recipes =
      FirebaseFirestore.instance.collection('recipes');

  Future<void> addCategory(String categoryAdd) {
    return category.add({
      'category': categoryAdd,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getCategoryStream() {
    final categoryStream =
        category.orderBy('timestamp', descending: true).snapshots();
    return categoryStream;
  }

  Future<void> updateCategory(String docID, String newCategory) {
    return category.doc(docID).update({
      'category': newCategory,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteCategory(String docID) {
    return category.doc(docID).delete();
  }

  Future<void> addRecipe(String selectedCategory, Map<String, dynamic> recipeData) async {
    try {
      // Create a reference to the 'recipes' collection under the selected category
      CollectionReference categoryRecipes = recipes.doc(selectedCategory).collection('recipes');
      
      // Add the recipe data to the 'recipes' collection under the selected category
      await categoryRecipes.add(recipeData);
    } catch (error) {
      print("Error adding recipe to Firestore: $error");
      // Handle the error as needed
    }
  }

  Future<Map<String, dynamic>> getRecipeData(String selectedCategory) async {
  try {
    // Create a reference to the 'recipes' collection under the selected category
    CollectionReference categoryRecipes = recipes.doc(selectedCategory).collection('recipes');

    // Fetch the first document (you might need to adjust this based on your use case)
    QuerySnapshot snapshot = await categoryRecipes.get();
    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot document = snapshot.docs.first;
      Map<String, dynamic> recipeData = document.data() as Map<String, dynamic>;
      return recipeData;
    } else {
      print("No recipe data found for category: $selectedCategory");
      return {}; // Return an empty map or handle accordingly if no data is found
    }
  } catch (error) {
    print("Error getting recipe data from Firestore: $error");
    // Handle the error as needed
    return {}; // Return an empty map or handle accordingly in case of an error
  }
}

}

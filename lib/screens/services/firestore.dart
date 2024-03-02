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

  Future<void> addRecipe(
      String selectedCategory, Map<String, dynamic> recipeData) async {
    try {
      if (selectedCategory == null) {
        // Handle the case where selectedCategory is null
        print("Selected category is null. Unable to add recipe.");
        return;
      }

      // Create a reference to the 'recipes' collection under the selected category
      CollectionReference categoryRecipes =
          recipes.doc(selectedCategory).collection('recipes');

      // Add the recipe data to the 'recipes' collection under the selected category
      await categoryRecipes.add(recipeData);
    } catch (error) {
      print("Error adding recipe to Firestore: $error");
      // Handle the error as needed
    }
  }

  Future<List<Map<String, dynamic>>?> getRecipeData(
      String? selectedCategory) async {
    try {
      if (selectedCategory == null) {
        print("Selected category is null. Unable to fetch recipe data.");
        return null;
      }

      CollectionReference categoryRecipes =
          recipes.doc(selectedCategory).collection('recipes');

      QuerySnapshot snapshot = await categoryRecipes.get();

      if (snapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> recipesList =
            snapshot.docs.map((DocumentSnapshot document) {
          // Include the document ID in the recipe data
          Map<String, dynamic> recipeData =
              document.data() as Map<String, dynamic>;
          recipeData['id'] = document.id;
          return recipeData;
        }).toList();

        return recipesList;
      } else {
        print("No recipe data found for category: $selectedCategory");
        return null;
      }
    } catch (error) {
      print("Error getting recipe data from Firestore: $error");
      return null;
    }
  }

  Future<void> deleteRecipe(String selectedCategory, String docID) async {
    try {
      // Replace "WorkoutList" with the appropriate collection for your categories
      await FirebaseFirestore.instance
          .collection(
              'recipes') // Adjust collection name based on your data structure
          .doc(selectedCategory)
          .collection('recipes')
          .doc(docID)
          .delete();
      print('Recipe deleted: $docID');
    } catch (error) {
      print('Error deleting recipe: $error');
    }
  }

  Future<void> updateRecipe(String selectedCategory, String docID,
      Map<String, dynamic> updatedRecipeData) async {
    try {
      if (selectedCategory == null || docID == null) {
        // Handle the case where selectedCategory or docID is null
        print("Selected category or docID is null. Unable to update recipe.");
        return;
      }

      // Create a reference to the 'recipes' collection under the selected category
      CollectionReference categoryRecipes =
          recipes.doc(selectedCategory).collection('recipes');

      // Update the recipe data in the 'recipes' collection under the selected category
      await categoryRecipes.doc(docID).update(updatedRecipeData);
    } catch (error) {
      print("Error updating recipe in Firestore: $error");
      // Handle the error as needed
    }
  }

  Stream<QuerySnapshot> getRecipesStream(String selectedCategory) {
    print('Selected Category: $selectedCategory');

    final categoryRecipesStream = recipes
        .doc(selectedCategory)
        .collection('recipes')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return categoryRecipesStream;
  }

// Future<List<Map<String, dynamic>>?> fetchRecipesByCategory(String? selectedCategory) async {
//     try {
//       if (selectedCategory == null) {
//         print("Selected category is null. Unable to fetch recipes.");
//         return null;
//       }

//       CollectionReference categoryRecipes = recipes.doc(selectedCategory).collection('recipes');

//       QuerySnapshot snapshot = await categoryRecipes.get();

//       if (snapshot.docs.isNotEmpty) {
//         List<Map<String, dynamic>> recipesList = snapshot.docs.map((DocumentSnapshot document) {
//           // Include the document ID in the recipe data
//           Map<String, dynamic> recipeData = document.data() as Map<String, dynamic>;
//           recipeData['id'] = document.id;
//           return recipeData;
//         }).toList();

//         return recipesList;
//       } else {
//         print("No recipes found for category: $selectedCategory");
//         return null;
//       }
//     } catch (error) {
//       print("Error fetching recipes from Firestore: $error");
//       return null;
//     }
//   }
}

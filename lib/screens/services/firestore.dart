import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future addUserDetails(String fullName, String email) async {
    await FirebaseFirestore.instance.collection('Users').add({
      'full name': fullName,
      'email': email,
    });
  }

  Future<void> createUserDocument(
      String uid, String fullName, String email) async {
    await _firestore.collection('Users').doc(uid).set({
      'full name': fullName,
      'email': email,
    });
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('Users').doc(uid).get();

      if (snapshot.exists) {
        return snapshot.data();
      } else {
        print("Document does not exist for UID: $uid");
        return null;
      }
    } catch (error) {
      print("Error fetching user data: $error");
      return null;
    }
  }

  Future<void> updateUserDetails(String fullName, String email,
      String? description, String? phone, String? photoBase64) async {
    try {
      String uid = _auth.currentUser!.uid; // Get the current user's UID

      await _firestore.collection('Users').doc(uid).set({
        'full name': fullName,
        'email': email,
        'description': description,
        'phone': phone,
        'photo': photoBase64,
      }, SetOptions(merge: true)); // Merge with existing data if any
    } catch (error) {
      print("Error updating user details: $error");
      throw error; // Rethrow the error for handling at the calling site
    }
  }

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
    String selectedCategory,
    Map<String, dynamic> recipeData,
  ) async {
    if (selectedCategory == null) {
      print("Selected category is null. Unable to add recipe.");
      return;
    }

    try {
      String docID = recipes.doc().id;

      await recipes
          .doc(selectedCategory)
          .collection('recipes')
          .doc(docID)
          .set(recipeData);

      await recipes.doc('All').collection('recipes').doc(docID).set(recipeData);
    } catch (error) {
      print("Error adding recipe to Firestore: $error");
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
        return snapshot.docs.map((DocumentSnapshot document) {
          return {
            ...document.data() as Map<String, dynamic>,
            'id': document.id
          };
        }).toList();
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
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(selectedCategory)
          .collection('recipes')
          .doc(docID)
          .delete();

      await FirebaseFirestore.instance
          .collection('recipes')
          .doc('All')
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
    }
  }

  Stream<List<Map<String, dynamic>>> getRecipeStream(String selectedCategory) {
    try {
      if (selectedCategory == null) {
        print("Selected category is null. Unable to create recipe stream.");
        return Stream.value([]);
      }

      // Create a reference to the 'recipes' collection under the selected category
      CollectionReference categoryRecipes = FirebaseFirestore.instance
          .collection('recipes')
          .doc(selectedCategory)
          .collection('recipes');

      // Create and return the stream
      return categoryRecipes.snapshots().map((QuerySnapshot snapshot) {
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
          return [];
        }
      });
    } catch (error) {
      print("Error creating recipe stream from Firestore: $error");
      return Stream.value([]);
    }
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserFirestoreServices {
//   final String userId;

//   UserFirestoreServices({required this.userId});

//   Future<void> updateFavorites(Map<String, dynamic> recipeData) async {
//     // Reference to the user's favorites collection
//     CollectionReference favoritesCollection = FirebaseFirestore.instance
//         .collection('UsersFav')
//         .doc(userId)
//         .collection('favorites');

//     String recipeId = recipeData['recipeId'];

//     // Use the specified recipeId as the document ID
//     DocumentReference recipeRef = favoritesCollection.doc(recipeId);

//     // Check if the recipe is already in favorites
//     bool isFavorite = await recipeRef.get().then((doc) => doc.exists);

//     if (isFavorite) {
//       // Remove from favorites
//       await recipeRef.delete();
//     } else {
//       // Add to favorites
//       await recipeRef.set(recipeData);
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app1/screens/Hive/data_model.dart';
import 'package:recipe_app1/screens/Hive/function.dart';
import 'package:recipe_app1/screens/components/drawer.dart';
import 'package:recipe_app1/screens/components/normalbutton.dart';
import 'package:recipe_app1/screens/components/widgets.dart';
import 'package:recipe_app1/screens/loginscreen/signin.dart';
import 'package:recipe_app1/screens/services/firestore.dart';
import 'package:recipe_app1/screens/userscreen/edit_profile.dart';
import 'package:recipe_app1/screens/userscreen/recipe_details.dart';
import 'package:recipe_app1/screens/userscreen/user_add_recipe_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirestoreServices firestoreServices = FirestoreServices();
  Map<String, dynamic>? userData;
  File? profilePhoto;
  late ValueNotifier<List<UserRecipe>> recipeListNotifier;
  String recipeBoxName = 'recipe_db';

  String? photoBase64;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
    Hive.openBox("recipe_db");
    recipeListNotifier = HiveService.watchAllRecipes();
  }

  Future<void> fetchUserData() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    print("UID: $uid");

    if (uid != null) {
      try {
        Map<String, dynamic>? data = await firestoreServices.getUserData(uid);

        if (data != null) {
          // Update the state with the retrieved data
          setState(() {
            userData = data;
          });
        } else {
          print("User data is null");
        }
      } catch (error) {
        print("Error fetching user data: $error");
      }
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MyDrawer(userData: userData),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My profile',
                  style: CustomWidget.heading2(context),
                ),
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Color(0xFFE23E3E),
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: userData != null && userData!['photo'] != null
                        ? Image.memory(
                            base64Decode(userData!['photo']),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                        : Placeholder(
                            fallbackWidth: 120,
                            fallbackHeight: 120,
                          ),
                  ),
                ),
              ],
            ),
            if (userData != null)
              Column(
                children: [
                  ListTile(
                    title: Text(
                      '${userData!['full name'] ?? 'N/A'}',
                      style: CustomWidget.heading32(context),
                    ),
                  ),
                  ListTile(
                    title: Text('${userData!['description'] ?? 'N/A'}'),
                  ),
                ],
              ),
            Divider(),
            Expanded(
              child: ValueListenableBuilder<List<UserRecipe>>(
                valueListenable: recipeListNotifier,
                builder: (context, recipes, _) {
                  return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return GestureDetector(
                        onTap: () {
                          print('Tapped recipe index: $index');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserAddRecipe(
                                  recipe: recipe, recipeIndex: index),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                  child: SizedBox(
                                    height: 150,
                                    child: recipe.imagePath.isNotEmpty
                                        ? Image.file(
                                            File(recipe.imagePath),
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/placeholder_image.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE23E3E),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(14),
                                      bottomRight: Radius.circular(14),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          recipe.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _deleteRecipe(recipe);
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteRecipe(UserRecipe recipe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${recipe.name}?'),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              NormalButton(
                text: 'Yes',
                onPressed: () async {
                  final recipeBox =
                      await Hive.openBox<UserRecipe>(recipeBoxName);
                  final index = recipeBox.values.toList().indexOf(recipe);
                  if (index != -1) {
                    await HiveService.deleteRecipe(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Recipe deleted successfully!'),
                      ),
                    );
                  }
                  print(index);
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 10),
              NormalButton(
                text: 'No',
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

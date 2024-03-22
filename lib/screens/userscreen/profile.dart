import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app1/screens/Hive/data_model.dart';
import 'package:recipe_app1/screens/Hive/function.dart';
import 'package:recipe_app1/screens/components/normalbutton.dart';
import 'package:recipe_app1/screens/components/widgets.dart';
import 'package:recipe_app1/screens/loginscreen/signin.dart';
import 'package:recipe_app1/screens/services/firestore.dart';
import 'package:recipe_app1/screens/userscreen/recipe_details.dart';
import 'package:recipe_app1/screens/userscreen/user_add_recipe_details.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirestoreServices firestoreServices = FirestoreServices();
  Map<String, dynamic>? userData;
  File? profilePhoto;
  late ValueNotifier<List<UserRecipe>> recipeListNotifier;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My profile',
                  style: CustomWidget.heading2(context),
                ),
                
                IconButton(
                  icon: const Icon(
                    Icons.exit_to_app,
                  ),
                  onPressed: () {
                    showLogoutConfirmationDialog();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _getImage(context: context);
                  },
                  child: CircleAvatar(
                    radius: 50,
                  ),
                ),
                CustomWidget.customButton(context, 'Edit profile', () {}),
              ],
            ),
            if (userData != null)
              Column(
                children: [
                  ListTile(
                    title: Text('${userData!['full name'] ?? 'N/A'}'),
                  ),
                  ListTile(
                    title: Text('${userData!['email'] ?? 'N/A'}'),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserAddRecipe(recipe: recipe),
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
                                        onPressed: () {},
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

  void showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Oh no! You are leaving . . . .'),
        content: const Text('Are you sure?'),
        actions: [
          NormalButton(
            text: 'Naah, just kidding',
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: double.infinity,
            child:
                CustomWidget.customButton(context, 'Yes,log Me Out', () async {
              // Perform the logout if the user confirms
              await FirebaseAuth.instance.signOut();

              // Show a Snackbar indicating successful logout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully!'),
                ),
              );

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignIn()),
                (Route<dynamic> route) => false,
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _getImage({required BuildContext context}) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    print("Image Path: ${pickedFile.path}");

    setState(() {
      profilePhoto = File(pickedFile.path);
    });
  }
}

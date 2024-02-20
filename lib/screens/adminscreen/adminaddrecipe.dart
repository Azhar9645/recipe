import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app1/screens/adminscreen/bottomnavbaradmin.dart';
import 'package:recipe_app1/screens/components/mybutton.dart';
import 'package:recipe_app1/screens/components/mytextfield.dart';
import 'package:recipe_app1/screens/services/firestore.dart';

class AdminRecipeAdd extends StatefulWidget {
  AdminRecipeAdd({Key? key}) : super(key: key);

  @override
  _AdminRecipeAddState createState() => _AdminRecipeAddState();
}

class _AdminRecipeAddState extends State<AdminRecipeAdd> {
  // List<File> selectedImages = [];
  String? selectedCategory;
  File? photo;
  String? photoBase64;
  List<Widget> ingredientRows = [];
  final FirestoreServices firestoreServices = FirestoreServices();

  final recipeNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final ingredientController = TextEditingController();
  final quantityController = TextEditingController();
  final directionController = TextEditingController();
  final timeController = TextEditingController();

  List<Map<String, TextEditingController>> ingredientsList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomAdminNavigationBar()));
          },
        )),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter Recipe Details',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () => _getImage(context: context),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE23E3E),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: photo != null
                          ? Image.file(photo!, fit: BoxFit.cover)
                          : Center(
                              child: Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Color(0xFFC1C1C1),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                MyTextfield(
                  maxline: 1,
                  controller: recipeNameController,
                  hintText: '',
                  
                ),

                const Text(
                  'Select category',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                // StreamBuilder to listen for changes in category data
                StreamBuilder<QuerySnapshot>(
                  stream: firestoreServices.getCategoryStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    // Dropdown field - Replace this with your actual dropdown widget
                    return DropdownButtonFormField<String>(
                      items:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        String categoryText =
                            data['category'] ?? "defaultCategory";

                        return DropdownMenuItem<String>(
                          value: categoryText,
                          child: Text(categoryText.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        // Handle the selected value
                        print('Selected category: $value');
                        setState(() {
                          selectedCategory =
                              value; // Update the selectedCategory here
                        });
                      },
                      hint: const Text('Select Category'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFFE23E3E),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xFFE23E3E),
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Color(0xFFE23E3E)),
                        ),
                      ),
                      isExpanded: true,
                      elevation: 2,
                    );
                  },
                ),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                MyTextfield(
                  controller: descriptionController,
                  hintText: '',
                  
                  maxline: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          ingredientsList.add({
                            'ingredient': TextEditingController(),
                            'quantity': TextEditingController(),
                          });
                        });
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: ingredientsList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: MyTextfield(
                              controller: ingredientsList[index]['ingredient']!,
                              hintText: 'Item name',
                              
                              maxline: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: MyTextfield(
                              controller: ingredientsList[index]['quantity']!,
                              hintText: 'Quantity',
                              
                              maxline: 1,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                ingredientsList.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Text(
                  'Direction',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                MyTextfield(
                  controller: directionController,
                  hintText: 'Step by step',
                  maxline: null,
                  isNumbered: true,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyTextfield(
                        controller: timeController,
                        hintText: 'hh:mm',
                        
                        maxline: 1,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 15),
                MyButton(
                  text: 'Save my recipe',
                  onPressed: () async {
                    if (selectedCategory == null) {
                      // Handle the case where no category is selected
                      return;
                    }

                    // Create a map with all the data
                    Map<String, dynamic> recipeData = {
                      'name': recipeNameController.text,
                      'category': selectedCategory,
                      'description': descriptionController.text,
                      'photo': photoBase64,
                      // Add other fields as needed
                    };

                    // Add ingredients to the recipeData map
                    List<Map<String, dynamic>> ingredientsData = [];
                    for (var ingredientMap in ingredientsList) {
                      ingredientsData.add({
                        'ingredient': ingredientMap['ingredient']!.text,
                        'quantity': ingredientMap['quantity']!.text,
                      });
                    }
                    recipeData['ingredients'] = ingredientsData;

                    // Add direction and time to the recipeData map
                    recipeData['direction'] = directionController.text;
                    recipeData['time'] = timeController.text;

                    // Save the data to Firestore with the selected category
                    await firestoreServices.addRecipe(
                        selectedCategory!, recipeData);

                    // Fetch recipe data for the selected category
                    Map<String, dynamic> fetchedRecipeData =
                        await firestoreServices
                            .getRecipeData(selectedCategory!);

                    // Show the success dialog or navigate to the next screen
                    showDialog(
                      context: context,
                      builder: (context) =>
                          customDialog(context, fetchedRecipeData),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customDialog(BuildContext context, Map<String, dynamic> fetchedRecipeData) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.thumb_up_outlined,
            color: Colors.black,
            size: 150,
          ),
          const SizedBox(height: 16),
          const Text(
            'Upload sucess',
            style: TextStyle(fontSize: 25),
          ),
          const Text(
            'Your recipe has been uploaded',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          MyButton(
              text: 'Back to home',
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomAdminNavigationBar()));
              })
        ],
      ),
    );
  }

  Future<void> _getImage({required BuildContext context}) async {
    try {
      final picker = ImagePicker();
      final XFile? imageSelect =
          await picker.pickImage(source: ImageSource.gallery);

      if (imageSelect == null) {
        // Handle image selection cancellation gracefully
        return;
      }

      Uint8List imageBytes = await imageSelect.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      setState(() {
        photo = File(imageSelect.path);
        photoBase64 = base64Image;
      });
    } catch (error) {
      print("Error picking image: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while selecting an image.'),
        ),
      );
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:recipe_app1/screens/adminscreen/bottomnavbaradmin.dart';
import 'package:recipe_app1/screens/components/mybutton.dart';
import 'package:recipe_app1/screens/components/mytextfield.dart';
import 'package:recipe_app1/screens/components/normalbutton.dart';
import 'package:recipe_app1/screens/services/firestore.dart';

class AdminRecipeAdd extends StatefulWidget {
  final Map<String, dynamic>? recipeData;
  final String? selectedCategory;

  // Constructor to receive initial data for editing
  AdminRecipeAdd({Key? key, this.recipeData, this.selectedCategory})
      : super(key: key);

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

  List<Map<String, TextEditingController>> ingredientsList = [];

  final recipeNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final ingredientController = TextEditingController();
  final quantityController = TextEditingController();
  final directionController = TextEditingController();
  final timeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.recipeData != null) {
      fillData();
    }
  }

  void fillData() {
    recipeNameController.text = widget.recipeData!['name'] ?? '';
    descriptionController.text = widget.recipeData!['description'] ?? '';
    directionController.text = widget.recipeData!['direction'] ?? '';
    timeController.text = widget.recipeData!['time'] ?? '';

    selectedCategory = widget.selectedCategory;

    photoBase64 = widget.recipeData!['photo'] ?? '';

    List<dynamic>? ingredientsData = widget.recipeData!['ingredients'];
    ingredientsList.clear();

    if (ingredientsData != null) {
      for (var ingredientData in ingredientsData) {
        TextEditingController ingredientController = TextEditingController();
        TextEditingController quantityController = TextEditingController();

        ingredientController.text = ingredientData['ingredient'] ?? '';
        quantityController.text = ingredientData['quantity'] ?? '';

        ingredientsList.add({
          'ingredient': ingredientController,
          'quantity': quantityController,
        });
      }
    }
  }

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
                  physics: NeverScrollableScrollPhysics(),
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
                      _showValidationDialog('Please select a category.');
                      return;
                    }

                    // Validate each field
                    if (!_validateTextField(recipeNameController, 'Name') ||
                        !_validateTextField(
                            descriptionController, 'Description') ||
                        !_validateIngredients() ||
                        !_validateTextField(directionController, 'Direction') ||
                        !_validateTextField(timeController, 'Time')) {
                      return;
                    }

                    // Create a map with all the data
                    Map<String, dynamic> recipeData = {
                      'name': recipeNameController.text.trim(),
                      'category': selectedCategory!,
                      'description': descriptionController.text.trim(),
                      'photo': photoBase64 ?? '',
                      // Add other fields as needed
                    };

                    // Add ingredients to the recipeData map
                    List<Map<String, dynamic>> ingredientsData = [];
                    for (var ingredientMap in ingredientsList) {
                      ingredientsData.add({
                        'ingredient': ingredientMap['ingredient']!.text.trim(),
                        'quantity': ingredientMap['quantity']!.text.trim(),
                      });
                    }
                    recipeData['ingredients'] = ingredientsData;

                    // Add direction and time to the recipeData map
                    recipeData['direction'] = directionController.text.trim();
                    recipeData['time'] = timeController.text.trim();

                    // Lottie animation
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.transparent,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Lottie.asset(
                              'assets/lottie/Animation - 1707395406065.json',
                              fit: BoxFit.fill,
                            ),
                          ],
                        ),
                      ),
                    );

                    if (widget.recipeData != null) {
                      // Update the existing recipe
                      await firestoreServices.updateRecipe(
                        selectedCategory!,
                        widget.recipeData!['id'],
                        recipeData,
                      );
                    } else {
                      // Save a new recipe to Firestore with the selected category
                      await firestoreServices.addRecipe(
                          selectedCategory!, recipeData);
                    }

                    // Dismiss the Lottie animation dialog
                    Navigator.pop(context);

                    // Navigate to CustomAdminNavigationBar
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomAdminNavigationBar(),
                      ),
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

  bool _validateTextField(TextEditingController controller, String fieldName) {
    if (controller.text.trim().isEmpty) {
      _showValidationDialog('Please enter $fieldName.');
      return false;
    }
    return true;
  }

  bool _validateIngredients() {
    for (var ingredientMap in ingredientsList) {
      if (ingredientMap['ingredient']!.text.trim().isEmpty) {
        _showValidationDialog('Please enter an item name for all ingredients.');
        return false;
      }
      if (ingredientMap['quantity']!.text.trim().isEmpty) {
        _showValidationDialog('Please enter a quantity for all ingredients.');
        return false;
      }
    }
    return true;
  }

  void _showValidationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cooking....'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 20),
            NormalButton(
              text: 'OK',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
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

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app1/screens/components/mybutton.dart';
import 'package:recipe_app1/screens/components/mytextfield.dart';
import 'package:recipe_app1/screens/services/firestore.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final FirestoreServices firestoreServices;

  EditProfile({Key? key, this.userData, required this.firestoreServices});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirestoreServices firestoreServices = FirestoreServices();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final descriptionController = TextEditingController();

  final phoneController = TextEditingController();

  File? photo;
  String? photoBase64;

  @override
  void initState() {
    super.initState();
    if (widget.userData != null) {
      nameController.text = widget.userData!['full name'] ?? '';
      emailController.text = widget.userData!['email'] ?? '';
      descriptionController.text = widget.userData!['description'] ?? '';
      phoneController.text = widget.userData!['phone'] ?? '';
      photoBase64 = widget.userData!['photo'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _getImage(context: context);
                },
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: photoBase64 != null
                      ? MemoryImage(base64Decode(photoBase64!))
                      : null, // Set backgroundImage to null if photoBase64 is null
                ),
              ),
              SizedBox(height: 20),
              MyTextfield(
                controller: nameController,
                hintText: 'Full name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Full name is required';
                  }

                  if (value.length < 5) {
                    return 'Full name must be at least 5 characters';
                  }

                  return null;
                },
                maxline: 1,
              ),
              const SizedBox(height: 20),
              MyTextfield(
                controller: emailController,
                hintText: 'abc@email.com',
                prefixIcon: const Icon(Icons.email_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Enter a valid email address';
                  }

                  return null;
                },
                maxline: 1,
              ),
              const SizedBox(height: 20),
              MyTextfield(
                controller: descriptionController,
                hintText: 'Description',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }

                  return null;
                },
                maxline: 4,
              ),
              const SizedBox(height: 20),
              MyTextfield(
                controller: phoneController,
                hintText: 'Phone no',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
                maxline: 1,
              ),
              SizedBox(height: 20),
              MyButton(
                text: 'Update Profile',
                onPressed: () async {
                  String fullName = nameController.text.trim();
                  String email = emailController.text.trim();
                  String description = descriptionController.text.trim();
                  String phone = phoneController.text.trim();

                  // Check if all required fields are filled
                  if (fullName.isNotEmpty &&
                      email.isNotEmpty &&
                      description.isNotEmpty &&
                      phone.isNotEmpty &&
                      photoBase64 != null) {
                    try {
                      // Call the updateUserDetails function
                      await widget.firestoreServices.updateUserDetails(
                          fullName, email, description, phone, photoBase64!);
                      // Show a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully.'),
                        ),
                      );
                      // Pop the screen
                      Navigator.pop(context);
                    } catch (error) {
                      // Show an error message if update fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Failed to update profile. Please try again.'),
                        ),
                      );
                    }
                  } else {
                    // Show an error message if any required field is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All fields are required.'),
                      ),
                    );
                  }
                },
              )
            ],
          ),
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
        return;
      }

      Uint8List imageBytes = await imageSelect.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      setState(() {
        // Update the photo variable with the selected image file
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

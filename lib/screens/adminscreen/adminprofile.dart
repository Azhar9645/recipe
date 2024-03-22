import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/adminscreen/bottomnavbaradmin.dart';
import 'package:recipe_app1/screens/components/color.dart';
import 'package:recipe_app1/screens/components/normalbutton.dart';
import 'package:recipe_app1/screens/components/widgets.dart';
import 'package:recipe_app1/screens/loginscreen/signin.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  
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
          SizedBox(
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
                SnackBar(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Admin',
                  style: CustomWidget.heading2(context),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.exit_to_app,
                    color: CustomColor.icon,
                  ),
                  onPressed: () {
                    showLogoutConfirmationDialog();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

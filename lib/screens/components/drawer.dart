import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app1/screens/Hive/data_model.dart'
    as HiveModel; // Import with prefix
import 'package:recipe_app1/screens/components/hiddenDrawer/about.dart';
import 'package:recipe_app1/screens/components/hiddenDrawer/help.dart';
import 'package:recipe_app1/screens/components/hiddenDrawer/settings.dart';
import 'package:recipe_app1/screens/components/normalbutton.dart';
import 'package:recipe_app1/screens/components/widgets.dart';
import 'package:recipe_app1/screens/loginscreen/signin.dart';
import 'package:recipe_app1/screens/services/firestore.dart';
import 'package:recipe_app1/screens/userscreen/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import without prefix

class MyDrawer extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const MyDrawer({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('UserData: $userData'); // Debugging: Print userData to console

    return Drawer(
      child: Container(
        color: Color(0xFFC1C1C1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                '${userData?['full name'] ?? 'N/A'}',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              accountEmail: Text(
                '${userData?['email'] ?? 'N/A'}',
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Color(0xFFE23E3E),
              ),
            ),
            ListTile(
              title: const Text(
                'About',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.info,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Help',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.help,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpPage()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfile(
                          userData: userData,
                          firestoreServices:
                              FirestoreServices())), // Use EditProfile without prefix
                );
              },
            ),
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showLogoutConfirmationDialog(BuildContext context) {
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
                CustomWidget.customButton(context, 'Yes, log Me Out', () async {
              // Perform the logout if the user confirms
              await signout(context);
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
}

Future<void> signout(BuildContext context) async {
  final _sharedPrefs = await SharedPreferences.getInstance();
  await _sharedPrefs.clear();

  await FirebaseAuth.instance.signOut();

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => SignIn()),
    (route) => false,
  );
}

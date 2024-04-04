import 'package:flutter/material.dart';
import 'package:recipe_app1/main.dart';
import 'package:recipe_app1/screens/components/bottomnavigationbar.dart';
import 'package:recipe_app1/screens/loginscreen/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkUserLogin();
  }

  Future<void> checkUserLogin() async {
    final SharedPreferences _sharedPrefs = await SharedPreferences.getInstance();
    final bool? _userLoggedIn = _sharedPrefs.getBool(SAVE_KEY);
    if (_userLoggedIn == null || _userLoggedIn == false) {
      Splash();
    } else {
      CustomCurvedNavigationBar();
    }
  }

  void gotoLogin() {
    // Implement your navigation logic to go to the login screen here
    // For example:
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
    );
  }

  void goToHome() {
    // Implement your navigation logic to go to the home screen here
    // For example:
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CustomCurvedNavigationBar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/logo/calum-lewis-vA1L1jRTM70-unsplash.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/logo/reciperover-high-resolution-logo-black-transparent.png',
              height: 180,
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Start',
              style: TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Cooking',
              style: TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Find best recipe for cooking',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  gotoLogin();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE23E3E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 7.0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Start Cooking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}

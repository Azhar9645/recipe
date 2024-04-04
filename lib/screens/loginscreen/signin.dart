import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app1/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe_app1/screens/adminscreen/bottomnavbaradmin.dart';
import 'package:recipe_app1/screens/components/bottomnavigationbar.dart';
import 'package:recipe_app1/screens/components/mybutton.dart';
import 'package:recipe_app1/screens/components/mytextfield.dart';
import 'package:recipe_app1/screens/loginscreen/resetpassword.dart';
import 'package:recipe_app1/screens/loginscreen/signup.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);

  final String adminemail = 'asru@gmail.com';
  final String adminepass = 'Azhar@0000';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                Image.asset(
                  'assets/logo/reciperover-high-resolution-logo-transparent.png',
                  width: 200,
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
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
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    ).hasMatch(value)) {
                      return 'Enter a valid Gmail address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Your password',
                  obscureText: true,
                  maxline: 1,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (!value.contains(RegExp(r'[A-Z]'))) {
                      return 'Password must contain at least one uppercase letter';
                    }
                    if (!value.contains(RegExp(r'[^\w]'))) {
                      return 'Password must contain at least one non-alphabetic character';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPassword()),
                      );
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 250,
                  child: MyButton(
                    text: 'Sign In',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (emailController.text == adminemail &&
                            passwordController.text == adminepass) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomAdminNavigationBar(),
                            ),
                          );
                        } else {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          )
                              .then(
                            (value) async {
                              final _sharedPrefs = await SharedPreferences.getInstance();
                              await _sharedPrefs.setBool(SAVE_KEY, true);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomCurvedNavigationBar(),
                                ),
                              );
                            },
                          ).catchError((error) {
                            // Handle authentication errors here
                            print("Error: $error");
                            showSnackbar(context, "Incorrect password");
                          });
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'OR',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Dont have any account?',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE23E3E),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

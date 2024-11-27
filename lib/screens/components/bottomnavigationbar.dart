import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:recipe_app1/screens/userscreen/addrecipe.dart';
import 'package:recipe_app1/screens/userscreen/cart.dart';
import 'package:recipe_app1/screens/userscreen/home.dart';
import 'package:recipe_app1/screens/userscreen/profile.dart';
import 'package:recipe_app1/screens/userscreen/wishlist.dart';

class CustomCurvedNavigationBar extends StatefulWidget {
  @override
  _CustomCurvedNavigationBarState createState() =>
      _CustomCurvedNavigationBarState();
}

class _CustomCurvedNavigationBarState extends State<CustomCurvedNavigationBar> {
  int index = 0;

  final screens = [
    Home(),
    Wishlist(),
    AddRecipe(),
    Cart(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[index], // Display the selected screen
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    // Check if the current screen is AddRecipe
    if (screens[index] is AddRecipe) {
      // If it is AddRecipe, don't show the bottom navigation bar
      return SizedBox.shrink(); // Empty SizedBox to hide the navigation bar
    }

    return CurvedNavigationBar(
      index: index,
      height: 70,
      items: const <Widget>[
        Icon(Icons.home, size: 25, color: Color(0xFFC1C1C1)),
        Icon(Icons.favorite, size: 25, color: Color(0xFFC1C1C1)),
        Icon(Icons.add, size: 25, color: Color(0xFFC1C1C1)),
        Icon(Icons.card_travel, size: 25, color: Color(0xFFC1C1C1)),
        Icon(Icons.person, size: 25, color: Color(0xFFC1C1C1)),
      ],
      color: Colors.white,
      buttonBackgroundColor: Color(0xFFE23E3E),
      backgroundColor: Colors.grey.shade200,
      animationDuration: Duration(milliseconds: 300),
      onTap: (index) => setState(() => this.index = index),
    );
  }
}

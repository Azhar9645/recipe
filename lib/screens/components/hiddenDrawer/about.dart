import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE23E3E),
        title: Text(
          'About Recipe Rover',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Recipe Rover',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Recipe Rover, your ultimate destination for discovering and sharing delicious recipes!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'App Overview:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Recipe Rover is a mobile application designed to help users discover, save, and share recipes from around the world. Whether you are a cooking enthusiast looking for new culinary inspirations or someone simply trying to make a quick meal, Recipe Rover has something for everyone.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Features:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildFeature('Admin Functionality',
                'Admins can add new recipes and manage existing ones.'),
            _buildFeature('User Recipe Management',
                'Users can save their favorite recipes and create their own recipes to share with others.'),
            _buildFeature('Offline Access',
                'Users can access saved recipes offline, allowing them to cook without an internet connection.'),
            _buildFeature('Cross-Platform Support',
                'Recipe Rover is available on both iOS and Android platforms for seamless user experience.'),
            SizedBox(height: 20),
            Text(
              'Terms and Conditions:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildTermsAndConditions(context),
            SizedBox(height: 20),
            Text(
              'Privacy Policy:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildPrivacyPolicy(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          description,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          'By using Recipe Rover, you agree to our Terms and Conditions. Please read them carefully.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 5),
        TextButton(
          onPressed: () {
            // Navigate to the full terms and conditions page
          },
          child: Text(
            'Read Terms and Conditions',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyPolicy(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          'Our Privacy Policy outlines how your data is collected, used, and shared when you use our app.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 5),
        TextButton(
          onPressed: () {
            // Navigate to the full privacy policy page
          },
          child: Text(
            'Read Privacy Policy',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

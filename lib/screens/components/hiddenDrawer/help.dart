import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE23E3E),
        title: Text(
          'Help',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Change color of back button
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          ListTile(
            title: Text('FAQs'),
            onTap: () {
              // Navigate to FAQs page
            },
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            title: Text('Contact Support'),
            onTap: () {
              // Navigate to contact support page
            },
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            title: Text('Report a Problem'),
            onTap: () {
              // Navigate to report a problem page
            },
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}

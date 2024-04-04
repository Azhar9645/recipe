import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE23E3E),
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white), 
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          ListTile(
            title: Text('Notification Settings'),
            onTap: () {
            },
            trailing: Icon(Icons.arrow_forward_ios),
          ),
         
          Divider(),
          ListTile(
            title: Text('Terms and Conditions'),
            onTap: () {
            },
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            title: Text('Contact Us'),
            onTap: () {
            },
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          
        ],
      ),
    );
  }
}

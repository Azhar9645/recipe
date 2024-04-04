import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TotalUsers extends StatefulWidget {
  const TotalUsers({Key? key}) : super(key: key);

  @override
  State<TotalUsers> createState() => _TotalUsersState();
}

class _TotalUsersState extends State<TotalUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            List<DocumentSnapshot> users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var userData = users[index].data() as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    title: Text(userData['full name'] ?? ''),
                    subtitle: Text(userData['email'] ?? ''),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

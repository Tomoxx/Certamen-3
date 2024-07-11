import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeveloperDetailPage extends StatelessWidget {
  final DocumentSnapshot developer;

  const DeveloperDetailPage({required this.developer, super.key});

  void _deleteDeveloper(BuildContext context) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this developer?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      FirebaseFirestore.instance
          .collection('developers')
          .doc(developer.id)
          .delete()
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Developer deleted')),
        );
        Navigator.of(context).pop(); // Go back to the previous page
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete developer: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(developer['name']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${developer['name']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Website: ${developer['website']}'),
            SizedBox(height: 8),
            Text('Endorsements: ${developer['endorsements']}'),
            Spacer(),
            ElevatedButton(
              onPressed: () => _deleteDeveloper(context),
              child: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}

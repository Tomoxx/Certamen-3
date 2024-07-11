import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublisherDetailPage extends StatelessWidget {
  final DocumentSnapshot publisher;

  const PublisherDetailPage({required this.publisher, super.key});

  void _deletePublisher(BuildContext context) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this publisher?'),
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
          .collection('publishers')
          .doc(publisher.id)
          .delete()
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Publisher deleted')),
        );
        Navigator.of(context).pop(); // Go back to the previous page
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete publisher: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(publisher['name']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${publisher['name']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Website: ${publisher['website']}'),
            SizedBox(height: 8),
            Text('Endorsements: ${publisher['endorsements']}'),
            Spacer(),
            ElevatedButton(
              onPressed: () => _deletePublisher(context),
              child: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}

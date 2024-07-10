import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GameDetailPage extends StatelessWidget {
  final DocumentSnapshot game;

  const GameDetailPage({required this.game, super.key});

  void _deleteGame(BuildContext context) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this game?'),
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
          .collection('games')
          .doc(game.id)
          .delete()
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Game deleted')),
        );
        Navigator.of(context).pop(); // Go back to the previous page
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete game: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = game['release_date'];
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(game['name']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${game['name']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Developer: ${game['developer']}'),
            SizedBox(height: 8),
            Text('Publisher: ${game['publisher']}'),
            SizedBox(height: 8),
            Text('Release Date: $formattedDate'),
            Spacer(),
            ElevatedButton(
              onPressed: () => _deleteGame(context),
              child: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:certamen_3/pages/game_form_page.dart';
import 'package:certamen_3/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'game_detail_page.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: FirestoreService().games(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              // Waiting for data
              return Center(child: CircularProgressIndicator());
            } else {
              // Data arrived, show on page
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var game = snapshot.data!.docs[index];
                  Timestamp timestamp = game['release_date'];
                  DateTime dateTime = timestamp.toDate();
                  String formattedDate =
                      DateFormat('dd-MM-yyyy').format(dateTime);
                  int price = game['price'];

                  return ListTile(
                    title: Text('${game['name']}'),
                    subtitle: Text(
                      'Developer: ${game['developer']}\n'
                      'Publisher: ${game['publisher']}\n'
                      'Price: \$${price.toStringAsFixed(2)}\n'
                      'Release Date: $formattedDate',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameDetailPage(game: game),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameFormPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

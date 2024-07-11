import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublisherFormPage extends StatefulWidget {
  @override
  _PublisherFormPageState createState() => _PublisherFormPageState();
}

class _PublisherFormPageState extends State<PublisherFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _endorsementsController = TextEditingController();

  void _addPublisher() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('publishers').add({
        'name': _nameController.text,
        'website': _websiteController.text,
        'endorsements': int.parse(_endorsementsController.text),
      }).then((_) {
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add publisher: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Publisher'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  if (value.length < 2) {
                    return 'The publisher name needs atleast 2 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(labelText: 'Website'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the website';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endorsementsController,
                decoration: InputDecoration(labelText: 'Endorsements'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of endorsements';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addPublisher,
                child: Text('Add Publisher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

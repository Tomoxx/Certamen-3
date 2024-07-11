import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeveloperFormPage extends StatefulWidget {
  @override
  _DeveloperFormPageState createState() => _DeveloperFormPageState();
}

class _DeveloperFormPageState extends State<DeveloperFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _endorsementsController = TextEditingController();

  void _addDeveloper() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('developers').add({
        'name': _nameController.text,
        'website': _websiteController.text,
        'endorsements': int.parse(_endorsementsController.text),
      }).then((_) {
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add developer: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Developer'),
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
                onPressed: _addDeveloper,
                child: Text('Add Developer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

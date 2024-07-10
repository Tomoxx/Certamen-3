import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GameFormPage extends StatefulWidget {
  const GameFormPage({super.key});

  @override
  _GameFormPageState createState() => _GameFormPageState();
}

class _GameFormPageState extends State<GameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _developerController = TextEditingController();
  final _publisherController = TextEditingController();
  DateTime? _releaseDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _releaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _releaseDate) {
      setState(() {
        _releaseDate = picked;
      });
    }
  }

  void _saveGame() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('games').add({
        'name': _nameController.text,
        'developer': _developerController.text,
        'publisher': _publisherController.text,
        'release_date': Timestamp.fromDate(_releaseDate!),
      }).then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Game Added')));
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add game: $error')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Game'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the game name';
                  }
                  if (value.length < 2) {
                    return 'The game name needs atleast 2 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _developerController,
                decoration: InputDecoration(labelText: 'Developer'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the developer name';
                  }
                  if (value.length < 2) {
                    return 'The developer name needs atleast 2 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _publisherController,
                decoration: InputDecoration(labelText: 'Publisher'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the publisher name';
                  }
                  if (value.length < 2) {
                    return 'The publisher name needs atleast 2 characters';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _releaseDate == null
                            ? 'No date chosen!'
                            : 'Release Date: ${DateFormat('yyyy-MM-dd').format(_releaseDate!)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select Date'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _releaseDate == null ? null : _saveGame,
                  child: Text('Save Game'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _developerController.dispose();
    _publisherController.dispose();
    super.dispose();
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_buddy/screens/shared/laoding.dart';
import 'package:reading_buddy/services/database.dart';

class NewBook extends StatefulWidget {
  final User user;

  NewBook({this.user});

  @override
  _NewBookState createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  final firestoreInstance = FirebaseFirestore.instance;

  File _image;

  String error = '';

  String title = '';
  int pagesNumber = 0;
  int startsAt = 0;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Reading Buddy'),
              backgroundColor: Colors.lightBlue,
              elevation: 0.0,
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => loading = true);
                      // create new book logic
                      await DatabaseService(uid: widget.user.uid)
                          .newBook(title, pagesNumber, startsAt);
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 15.0),
                    TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Book Title',
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'Enter a Book name' : null,
                        onChanged: (val) {
                          setState(() => title = val);
                        }),
                    SizedBox(height: 15.0),
                    TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Number of Pages',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (val) =>
                            val.isEmpty ? 'Enter the Number of Pages' : null,
                        onChanged: (val) {
                          setState(() => pagesNumber = int.parse(val));
                        }),
                    SizedBox(height: 15.0),
                    TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Book starts at Page',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (val) => val.isEmpty
                            ? 'Enter the Page Number on which the Book start'
                            : null,
                        onChanged: (val) {
                          setState(() => startsAt = int.parse(val));
                        }),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    Center(
                      child: _image == null
                          ? Text('Image not loaded')
                          : Image.file(_image),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reading_buddy/screens/shared/loading.dart';
import 'package:reading_buddy/services/database.dart';
import 'package:reading_buddy/services/storage.dart';

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

  final ImagePicker picker = ImagePicker();
  final Storage storage = Storage();

  File _image;

  String error = '';

  String title = '';
  int pagesNumber = 0;
  int startsAt = 0;

  _imgFromCamera() async {
    final PickedFile image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {
    final PickedFile image =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
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

                String coverUrl = await storage.uploadPic(_image, widget.user.uid); 

                await DatabaseService(uid: widget.user.uid)
                    .newBook(title, pagesNumber, startsAt, coverUrl);
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
              Row(
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: _image == null
                            ? Text('No image selected.')
                            : Image.file(_image),
                        iconSize: 100,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:
                                    Text("Title", textAlign: TextAlign.center),
                                content:
                                    Text('Take Picture or choose from Gallery'),
                                actions: <Widget>[
                                  FlatButton(
                                      child: Text('Take Picture'),
                                      onPressed: () {
                                        _imgFromCamera();
                                        FocusScope.of(context).unfocus();
                                        Navigator.of(context).pop();
                                      }),
                                  FlatButton(
                                    child: Text('Gallery'),
                                    onPressed: () {
                                      _imgFromGallery();
                                      FocusScope.of(context).unfocus();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      Text('Add a Cover'),
                    ],
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Book Title',
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'Enter a Book name' : null,
                      onChanged: (val) {
                        setState(() => title = val);
                      }
                    )
                  )
                ]
              ),
              SizedBox(height: 15.0),
              Column(
                children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Number of Pages',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) => val.isEmpty
                          ? 'Enter the Number of Pages'
                          : null,
                      onChanged: (val) {
                        setState(() => pagesNumber = int.parse(val));
                      }
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Book starts at Page',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) => val.isEmpty
                        ? 'Enter the Page Number on which the Book start'
                        : null,
                    onChanged: (val) {
                      setState(() => startsAt = int.parse(val));
                    }
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ]
              )
            ]
          )
        ),
      ),
    );
  }
}

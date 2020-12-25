import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_buddy/screens/home/book_list.dart';
import 'package:reading_buddy/screens/home/app_drawer.dart';
import 'package:reading_buddy/screens/new_book/new_book.dart';
import 'package:reading_buddy/services/database.dart';
import 'package:provider/provider.dart';
import 'package:reading_buddy/models/book.dart';

class Home extends StatelessWidget {

  final User user;

  Home({ this.user });

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Book>>.value(
      value: DatabaseService(uid: user.uid).books,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reading Buddy'),
          backgroundColor: Colors.lightBlue,
          elevation: 0.0,
        ),
        body: BookList(user: user,),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: Icon(Icons.add),
          backgroundColor: Colors.lightBlue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewBook(user: user)
              ) 
            ); 
          },
        ),
      drawer: AppDrawer(user: user,),
      ),
    );
  }
}
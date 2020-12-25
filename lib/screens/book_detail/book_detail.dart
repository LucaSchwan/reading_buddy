import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_buddy/models/book.dart';
import 'package:reading_buddy/screens/home/home.dart';
import 'package:reading_buddy/services/database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BookDetail extends StatefulWidget {

  final Book book;
  final User user;

  BookDetail({ this.book, this.user }); 
  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {

  int newCurrentPage;
  bool updated = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book'),
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
        actions: [
          FlatButton(
            child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              print('delete');
              final alert = Alert(
                context: context,
                title: 'Are you sure about that?',
                buttons: [
                  DialogButton(
                    color: Colors.lightBlue,
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    width: 120,
                  ),
                  DialogButton(
                    color: Colors.red,
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () async {
                      await DatabaseService().deleteBook(widget.book.docId);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => Home(user: widget.user)
                        ) 
                      );
                    },
                    width: 120,
                  ),
                ]
              );
              alert.show();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Text(widget.book.title),
          Text((updated ? newCurrentPage.toString() : widget.book.currentPage.toString()) + '/' + widget.book.pagesNumber.toString()),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: Icon(Icons.add),
          backgroundColor: Colors.lightBlue,
          onPressed: () {
            Alert(
              context: context, 
              title: 'Add your new Page Number',
              content: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'New Page Number',
                ),
                onChanged: (val) {
                  newCurrentPage = int.parse(val);
                }
              ),
              buttons: [
                DialogButton(
                  color: Colors.lightBlue,
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () async {
                    // create new book logic
                    if (newCurrentPage > widget.book.currentPage) {
                      setState(() => updated = true);
                      await DatabaseService().updatePageNumber(newCurrentPage, widget.book.docId);
                      Navigator.pop(context);
                    } else {
                      setState(() => error = 'You haven\'t read any pages. Please enter a new Page Number.');
                    }
                  },
                  width: 120,
                )
              ],
            ).show();
          },
        ),
    );
  }
}
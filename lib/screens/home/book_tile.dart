import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_buddy/models/book.dart';
import 'package:reading_buddy/services/database.dart';
import 'package:reading_buddy/screens/home/home.dart';

class BookTile extends StatefulWidget {

  final Book book;
  final User user;

  BookTile({ this.book, this.user });
  @override
  _BookTileState createState() => _BookTileState();
}

class _BookTileState extends State<BookTile>{

  int newCurrentPage;
  bool updated = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: Column(
          children: [
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 10.0),
                Image.network(
                  widget.book.coverUrl,
                  scale: 37.0,
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.book.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: <TextSpan>[
                                  TextSpan(text: widget.book.currentPage.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: ' of '),
                                  TextSpan(text: widget.book.pagesNumber.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                                ]
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('New Page Number', textAlign: TextAlign.center),
                                    content: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(labelText: 'New Page Number'),
                                      onChanged: (val) {
                                        newCurrentPage = int.parse(val);
                                      }
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Set'),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          if (newCurrentPage >= widget.book.currentPage) {
                                            setState(() => updated = true);
                                            await DatabaseService().updatePageNumber(newCurrentPage, widget.book.docId);
                                            Navigator.pop(context);
                                          } else {
                                            setState(() => error = 'You haven\'t read any pages. Please enter a new Page Number.');
                                          }
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
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete'),
                                    content: Text('Are you sure you want to delete this Book?',textAlign: TextAlign.center),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Delete'),
                                        onPressed: () async {
                                          await DatabaseService().deleteBook(widget.book.docId);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                            builder: (context) => Home(user: widget.user)
                                            )
                                          );
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
                            }
                          ),
                        ],
                      ),
                    ]
                  ),
                ),
                SizedBox(width: 10.0)
              ]
            ),
            SizedBox(height: 10.0),
          ]
        )
      ),
    );
  }
}

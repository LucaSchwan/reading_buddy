import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_buddy/models/book.dart';
import 'package:reading_buddy/screens/book_detail/book_detail.dart';

class BookTile extends StatelessWidget {

  final Book book;
  final User user;

  BookTile({ this.book, this.user });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: InkWell(
          splashColor: Colors.lightBlue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetail(book: book, user: user,)
              ) 
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.lightBlue,
              // book cover
            ),
            title: Text(book.title),
            subtitle: Text(book.currentPage.toString() + '/' + book.pagesNumber.toString()),
          ),
        ),
      ),
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reading_buddy/models/book.dart';
import 'package:provider/provider.dart';
import 'package:reading_buddy/screens/home/book_tile.dart';
import 'package:reading_buddy/screens/shared/laoding.dart';

class BookList extends StatefulWidget {

  final User user;

  const BookList({ this.user });

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  @override
  Widget build(BuildContext context) {

    final books = Provider.of<List<Book>>(context);

    bool loading = false;

    if (books == null) {
      loading = true;
    } else {
      loading = false;
    }

    return loading ? Loading() : ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookTile(book: books[index], user: widget.user,);
      },
    );
  }
}
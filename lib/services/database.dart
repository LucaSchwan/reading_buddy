import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_buddy/models/book.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference booksCollection = FirebaseFirestore.instance.collection('books');

  Future newBook(String title, int pagesNumber, int startsAt) async {
    return await booksCollection.add(
      {
        'book_title' : title,
        'pages_number' : pagesNumber,
        'starts_at': startsAt,
        'current_page' : startsAt,
        'started_at' : new DateTime.now(),
        'user_uid' : uid,
        'cover_url' : '',
      }
    );
  }

  Future updatePageNumber(int newPageNumber, String docId) async {
    return await booksCollection.doc(docId).update({
      'current_page': newPageNumber
    });
  }

  Future deleteBook(String docId) async {
    return await booksCollection.doc(docId).delete();
  }

  // book list from snapshot
  List<Book> _bookListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Book(
        title: doc.data()['book_title'] ?? '',
        pagesNumber: doc.data()['pages_number'] ?? '',
        startsAt: doc.data()['starts_at'] ?? 0,
        currentPage: doc.data()['current_page'] ?? 0,
        startedAt: doc.data()['started_at'] ?? 0,
        userUid: doc.data()['user_uid'] ?? '',
        coverUrl: doc.data()['cover_url'] ?? '',
        docId: doc.id ?? '',
      );
    }).toList();
  }

  // get books stream
  Stream<List<Book>> get books {
    return booksCollection.where('user_uid', isEqualTo: uid).snapshots()
    .map(_bookListFromSnapshot);
  }
}
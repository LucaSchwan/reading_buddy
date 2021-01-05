import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_buddy/models/book.dart';
import 'package:reading_buddy/models/stats.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference booksCollection = FirebaseFirestore.instance.collection('books');
  final CollectionReference userStatsCollection = FirebaseFirestore.instance.collection('userStats');

  Future newBook(String title, int pagesNumber, int startsAt, String coverUrl) async {
    return await booksCollection.add(
      {
        'book_title' : title,
        'pages_number' : pagesNumber,
        'starts_at': startsAt,
        'current_page' : startsAt,
        'started_at' : new DateTime.now(),
        'user_uid' : uid,
        'cover_url' : coverUrl,
      }
    );
  }

  Future newUserStats() async {
    return await userStatsCollection.add(
      {
        'user_uid' : uid,
        'created_at' : new DateTime.now(),
        'last_updated' : new DateTime.now(),
        'total_pages' : 0.0,
        'total_books' : 0.0,
        'books_per_week' : 0.0,
        'pages_per_week' : 0.0,
        'pages_per_day' : 0.0,
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

  // user stats from snapshot
  Stats _userStatsFromSnapshot (QuerySnapshot snapshot) {
    DocumentSnapshot doc = snapshot.docs[0]; 
    return Stats(
      userUid: doc.data()['user_uid'] ?? '',
      createdAt: doc.data()['created_at'] ?? '',
      lastUpdated: doc.data()['last_updated'] ?? '',
      totalPages: doc.data()['total_pages'] ?? '',
      booksPerWeek: doc.data()['books_per_week'] ?? '',
      pagesPerWeek: doc.data()['pages_per_week'] ?? '',
      pagesPerDay: doc.data()['pages_per_day'] ?? '',
    );
  }
  
  // get userStats stream
  Stream<Stats> get userStats {
    return userStatsCollection.where('user_uid', isEqualTo: uid).snapshots()
      .map(_userStatsFromSnapshot);
  }
}

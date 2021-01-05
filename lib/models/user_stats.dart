class UserStats {
  
  final String userUid;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final int totalPages;
  final int totalBooks;
  final double booksPerWeek;
  final double pagesPerWeek;
  final double pagesPerDay;

  UserStats({
    this.userUid,
    this.createdAt,
    this.lastUpdated,
    this.totalPages,
    this.totalBooks,
    this.booksPerWeek,
    this.pagesPerWeek,
    this.pagesPerDay,
  });

}

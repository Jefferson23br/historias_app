class Book {
  final String id;
  final String title;
  final String coverUrl;
  final String categoryId;
  final int views15d;

  Book({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.categoryId,
    required this.views15d,
  });

  factory Book.fromMap(String id, Map<String, dynamic> m) {
    return Book(
      id: id,
      title: (m['title'] ?? '') as String,
      coverUrl: (m['coverUrl'] ?? '') as String,
      categoryId: (m['categoryId'] ?? '') as String,
      views15d: (m['views15d'] ?? 0) as int,
    );
  }
}
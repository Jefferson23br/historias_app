class Book {
  final String id;
  final String title;
  final String coverUrl;
  final String categoryId;
  final int views15d;
  final bool isPremium;
  final String pdfUrl;
  final String pdfUrl2; // novo campo

  Book({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.categoryId,
    required this.views15d,
    required this.isPremium,
    required this.pdfUrl,
    required this.pdfUrl2, // adicionado
  });

  factory Book.fromMap(String id, Map<String, dynamic> m) {
    bool parseBool(dynamic val) {
      if (val is bool) return val;
      if (val is String) return val.toLowerCase() == 'true';
      return false;
    }

    int parseInt(dynamic val) {
      if (val is int) return val;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return Book(
      id: id,
      title: (m['title'] ?? '') as String,
      coverUrl: (m['coverUrl'] ?? '') as String,
      categoryId: (m['categoryId'] ?? '') as String,
      views15d: parseInt(m['views15d']),
      isPremium: parseBool(m['isPremium']),
      pdfUrl: (m['pdfUrl'] ?? '') as String,
      pdfUrl2: (m['pdfUrl2'] ?? '') as String, // leitura em texto
    );
  }
}
class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromMap(String id, Map<String, dynamic> m) {
    return Category(id: id, name: (m['name'] ?? '') as String);
  }
}
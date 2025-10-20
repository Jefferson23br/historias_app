class Category {
  final String id;
  final String name;
  final String imageUrl;  // Adicione este campo

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,  // Adicione no construtor
  });

factory Category.fromMap(String id, Map<String, dynamic> data) {
  return Category(
    id: id,
    name: data['name'] ?? '',
    imageUrl: data['imageUrl'] ?? '',  // Corrigido para "imageUrl"
  );
}
}
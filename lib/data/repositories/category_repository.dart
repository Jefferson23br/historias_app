import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/category.dart';

class CategoryRepository {
  CategoryRepository._();
  static final instance = CategoryRepository._();

  final _db = FirebaseFirestore.instance;

  Stream<List<Category>> categoriesStream() {
    return _db.collection('categories')
      .orderBy('name')
      .snapshots()
      .map((s) => s.docs.map((d) => Category.fromMap(d.id, d.data())).toList());
  }
}
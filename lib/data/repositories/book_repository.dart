import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/book.dart';

class BookRepository {
  BookRepository._();
  static final instance = BookRepository._();

  final _db = FirebaseFirestore.instance;

  Stream<List<Book>> top10Stream() {
    return _db.collection('books')
      .orderBy('views15d', descending: true)
      .limit(10)
      .snapshots()
      .map((s) => s.docs.map((d) => Book.fromMap(d.id, d.data())).toList());
  }

  Stream<List<Book>> recommendationsForUserStream(String uid) {
    final userDoc = _db.collection('users').doc(uid);
    return userDoc.snapshots().asyncExpand((uSnap) {
      final favs = Map<String, dynamic>.from(uSnap.data()?['favorites'] ?? {});
      if (favs.isEmpty) return Stream.value(<Book>[]);
      String? best; int bestCount = -1;
      favs.forEach((k, v) {
        final c = (v as num).toInt();
        if (c > bestCount) { best = k; bestCount = c; }
      });
      if (best == null) return Stream.value(<Book>[]);
      return _db.collection('books')
        .where('categoryId', isEqualTo: best)
        .orderBy('views15d', descending: true)
        .limit(20)
        .snapshots()
        .map((s) => s.docs.map((d) => Book.fromMap(d.id, d.data())).toList());
    });
  }
}
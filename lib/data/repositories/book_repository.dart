import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/book.dart';

class BookRepository {
  BookRepository._();
  static final instance = BookRepository._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Book>> allBooksStream() {
    return _db.collection('books')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Book.fromMap(doc.id, doc.data()))
          .toList());
  }

  Stream<List<Book>> top10Stream() {
    return _db.collection('books')
      .orderBy('views15d', descending: true)
      .limit(10)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Book.fromMap(doc.id, doc.data()))
          .toList());
  }

  Stream<List<Book>> recommendationsForUserStream(String uid) {
    final userDoc = _db.collection('users').doc(uid);

    return userDoc.snapshots().asyncExpand((userSnapshot) {
      final data = userSnapshot.data();
      if (data == null) {
        return Stream.value(<Book>[]);
      }

      final favs = Map<String, dynamic>.from(data['favorites'] ?? {});

      if (favs.isEmpty) {
        return _db.collection('books')
          .limit(10)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Book.fromMap(doc.id, doc.data()))
              .toList());
      }

      String? bestCategory;
      int bestCount = -1;
      favs.forEach((categoryId, count) {
        final c = (count is int) ? count : (count is num ? count.toInt() : 0);
        if (c > bestCount) {
          bestCategory = categoryId;
          bestCount = c;
        }
      });

      if (bestCategory == null) {
        return _db.collection('books')
          .limit(10)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Book.fromMap(doc.id, doc.data()))
              .toList());
      }

      return _db.collection('books')
        .where('categoryId', isEqualTo: bestCategory)
        .orderBy('views15d', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Book.fromMap(doc.id, doc.data()))
            .toList());
    });
  }

  Future<String?> getUserType() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    final data = doc.data();
    if (data == null) return null;

    return data['userType'] as String?;
  }

  Stream<List<Book>> booksByCategoryStream(String categoryId) {
    return _db.collection('books')
      .where('categoryId', isEqualTo: categoryId)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => Book.fromMap(doc.id, doc.data()))
        .toList());
  }
}
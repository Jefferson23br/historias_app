import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Login com e-mail e senha
  Future<User?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // Cadastro com e-mail e senha
  Future<User?> signUp(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user != null) {
      // Cria doc básico no Firestore
      await _db.collection('users').doc(user.uid).set({
        'email': user.email,
        'nomeCompleto': '',
        'rua': '',
        'numero': '',
        'complemento': '',
        'bairro': '',
        'cidade': '',
        'estado': '',
        'pais': '',
        'cpf': '',
        'telefone': '',
        'userType': 'user_basic',
        'profileCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    return user;
  }

  // Login com Google
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user;
    if (user == null) return null;

    // Se não existir doc no Firestore, cria um básico
    final docRef = _db.collection('users').doc(user.uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'email': user.email,
        'nomeCompleto': user.displayName ?? '',
        'rua': '',
        'numero': '',
        'complemento': '',
        'bairro': '',
        'cidade': '',
        'estado': '',
        'pais': '',
        'cpf': '',
        'telefone': user.phoneNumber ?? '',
        'userType': 'user_basic',
        'profileCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return user;
  }

  // Verifica se perfil está completo
  Future<bool> isProfileComplete(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return false;
    final data = doc.data() ?? {};

    // Verifica se profileCompleted existe e é true
    if (data['profileCompleted'] == true) return true;

    // Caso contrário, verifica campos obrigatórios
    final requiredFields = ['nomeCompleto', 'cpf', 'telefone', 'cidade'];
    for (final key in requiredFields) {
      final v = data[key];
      if (v == null || (v is String && v.trim().isEmpty)) {
        return false;
      }
    }
    return true;
  }

  // Atualiza perfil - corrigido para retornar resultado
  Future<Map<String, dynamic>> updateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      data['profileCompleted'] = true;
      await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
      return {'success': true, 'message': 'Perfil atualizado com sucesso'};
    } catch (e) {
      return {'success': false, 'message': 'Erro ao atualizar perfil: $e'};
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
  }

  // Recuperar senha
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Stream do usuário autenticado
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
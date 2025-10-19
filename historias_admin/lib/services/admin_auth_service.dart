import 'package:cloud_functions/cloud_functions.dart';

class AdminAuthService {
  final _functions = FirebaseFunctions.instance;

  Future<({List<Map<String, dynamic>> users, String? nextPageToken})> listUsers({
    int pageSize = 50,
    String? pageToken,
  }) async {
    final callable = _functions.httpsCallable('listUsers');
    final result = await callable.call({
      'pageSize': pageSize,
      'pageToken': pageToken,
    });
    final data = Map<String, dynamic>.from(result.data as Map);
    final users = (data['users'] as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final next = data['nextPageToken'] as String?;
    return (users: users, nextPageToken: next);
  }

  Future<String> createUser({
    required String email,
    required String password,
    String? displayName,
    String role = 'user_free',
  }) async {
    final callable = _functions.httpsCallable('createUser');
    final result = await callable.call({
      'email': email,
      'password': password,
      'displayName': displayName,
      'role': role,
    });
    return result.data['uid'];
  }

  Future<void> setUserRole(String uid, String role) async {
    final callable = _functions.httpsCallable('setUserRole');
    await callable.call({'uid': uid, 'role': role});
  }

  Future<void> setUserDisabled(String uid, bool disabled) async {
    final callable = _functions.httpsCallable('setUserDisabled');
    await callable.call({'uid': uid, 'disabled': disabled});
  }

  Future<void> deleteUser(String uid) async {
    final callable = _functions.httpsCallable('deleteUser');
    await callable.call({'uid': uid});
  }
}
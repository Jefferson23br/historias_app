import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('projectId=${DefaultFirebaseOptions.currentPlatform.projectId}');
  print('appId=${DefaultFirebaseOptions.currentPlatform.appId}');
  try {
    await FirebaseFirestore.instance.collection('dev_ping').doc('test').set({
      'ok': true,
      'ts': DateTime.now().toIso8601String(),
    });
    print('dev_ping OK');
  } catch (e) {
    print('dev_ping ERROR: $e');
  }
  runApp(const MaterialApp(home: Scaffold(body: Center(child: Text('Ping')))));
}
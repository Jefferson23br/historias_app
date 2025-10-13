import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme.dart';
import 'core/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  try {
    final opts = DefaultFirebaseOptions.currentPlatform;
    print('Firebase projectId: ${opts.projectId}');
    print('Firebase appId: ${opts.appId}');
    final apiKeyTail = opts.apiKey.length >= 6
        ? opts.apiKey.substring(opts.apiKey.length - 6)
        : opts.apiKey;
    print('Firebase apiKey (fim): $apiKeyTail');
  } catch (e) {
    print('Erro ao imprimir opções do Firebase: $e');
  }

  runApp(const HistoriasApp());
}

class HistoriasApp extends StatelessWidget {
  const HistoriasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mundo de Histórias',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
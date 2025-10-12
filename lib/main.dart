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
      // Mantemos seu fluxo via rotas nomeadas:
      // - AppRoutes.login deve apontar para a tela de login
      // - Após login bem-sucedido, navegue para AppRoutes.home (HomeShell)
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
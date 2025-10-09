import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/story_page.dart';
import '../pages/premium_page.dart';
import '../pages/reset_password_page.dart';

class AppRoutes {
  // Rotas nomeadas
  static const String login = '/';
  static const String home = '/home';
  static const String story = '/story';
  static const String premium = '/premium';
  static const String resetPassword = '/reset-password';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );

      case story:
        // Aceita argumentos opcionais: { "storyId": String }
        final args = settings.arguments;
        String storyId = '';
        if (args is Map) {
          final dynamic id = args['storyId'];
          if (id is String) storyId = id;
        }
        return MaterialPageRoute(
          builder: (_) => StoryPage(storyId: storyId),
          settings: settings,
        );

      case premium:
        return MaterialPageRoute(
          builder: (_) => const PremiumPage(),
          settings: settings,
        );

      case resetPassword:
        // Aceita argumentos opcionais: { "prefillEmail": String }
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordPage(),
          settings: settings, // mantém os arguments para leitura na página
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text(
                'Página não encontrada 😅',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          settings: settings,
        );
    }
  }
}
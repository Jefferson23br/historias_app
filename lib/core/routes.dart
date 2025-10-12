import 'package:flutter/material.dart';

// Páginas existentes
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/story_page.dart';
import '../pages/premium_page.dart';
import '../pages/reset_password_page.dart';
import '../pages/forgot_email_page.dart';

// Caso você tenha criado o HomeShell (BottomNavigation + IndexedStack) e deseje usá-lo,
// troque o import e o case 'home' abaixo para ele.
// import '../app_shell/home_shell.dart';

class AppRoutes {
  // Rotas nomeadas
  static const String login = '/';            // Tela inicial do app (login)
  static const String home = '/home';         // Tela principal pós-login
  static const String story = '/story';       // Tela de leitura/detalhes de história
  static const String premium = '/premium';   // Tela Premium
  static const String resetPassword = '/reset-password';
  static const String forgotEmail = '/forgot-email';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );

      case home:
        // Opção 1: HomePage como Home principal
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );

        // Opção 2: HomeShell como Home principal (descomente se estiver usando o shell)
        // return MaterialPageRoute(
        //   builder: (_) => const HomeShell(),
        //   settings: settings,
        // );

      case story:
        // Espera argumentos: {'storyId': '...'}
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => StoryPage(
            storyId: args?['storyId'] ?? '',
          ),
          settings: settings,
        );

      case premium:
        return MaterialPageRoute(
          builder: (_) => const PremiumPage(),
          settings: settings,
        );

      case resetPassword:
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordPage(),
          settings: settings,
        );

      case forgotEmail:
        return MaterialPageRoute(
          builder: (_) => const ForgotEmailPage(),
          settings: settings,
        );

      default:
        // Fallback: rota não encontrada
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
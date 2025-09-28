import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/story_page.dart';
import '../pages/premium_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String story = '/story';
  static const String premium = '/premium';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      
      case story:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => StoryPage(
            storyId: args?['storyId'] ?? '',
          ),
        );
      
      case premium:
        return MaterialPageRoute(
          builder: (_) => const PremiumPage(),
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
        );
    }
  }
}
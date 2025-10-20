import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../app_shell/home_shell.dart';
import '../pages/story_page.dart';
import '../pages/premium_page.dart';
import '../pages/signup_page.dart';
import '../pages/complete_profile_page.dart';
import '../pages/reset_password_page.dart';
import '../pages/forgot_email_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String story = '/story';
  static const String premium = '/premium';
  static const String signup = '/signup';
  static const String completeProfile = '/complete-profile';
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
        return MaterialPageRoute(
          builder: (_) => const HomeShell(),
          settings: settings,
        );

      case story:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => StoryPage(
            storyId: args?['storyId'] ?? '',
            pdfUrl: args?['pdfUrl'] ?? '',
            title: args?['title'] ?? 'História',
          ),
          settings: settings,
        );

      case premium:
        return MaterialPageRoute(
          builder: (_) => const PremiumPage(),
          settings: settings,
        );

      case signup:
        return MaterialPageRoute(
          builder: (_) => const SignupPage(),
          settings: settings,
        );

      case completeProfile:
        return MaterialPageRoute(
          builder: (_) => const CompleteProfilePage(),
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
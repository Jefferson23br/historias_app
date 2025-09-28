import 'package:flutter/material.dart';
import '../core/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -40,
              left: -20,
              child: _softCircle(120, colorScheme.secondary.withOpacity(0.15)),
            ),
            Positioned(
              top: 60,
              right: -30,
              child: _softCircle(160, const Color(0xFFFFD66E).withOpacity(0.18)),
            ),
            Positioned(
              bottom: -50,
              left: -30,
              child: _softCircle(180, colorScheme.primary.withOpacity(0.12)),
            ),

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: Text(
                        '📖',
                        style: theme.textTheme.headlineMedium?.copyWith(fontSize: 36),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Aplicativo de Histórias',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Crie sua conta e veja a magia acontecer',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Entrar',
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          const SizedBox(height: 12),

                          TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              suffixIcon: TextButton(
                                onPressed: () {

                                },
                                child: const Text('Esqueci meu email'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          TextField(
                            controller: _passwordCtrl,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _obscure ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      setState(() => _obscure = !_obscure);
                                    },
                                  ),
                                  TextButton(
                                    onPressed: () {
                                    },
                                    child: const Text('Esqueci minha senha'),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, AppRoutes.home);
                              },
                              child: const Text('Entrar'),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey[300])),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text('ou', style: TextStyle(color: Colors.grey[600])),
                              ),
                              Expanded(child: Divider(color: Colors.grey[300])),
                            ],
                          ),

                          const SizedBox(height: 12),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _SocialIconButton(
                                tooltip: 'Entrar com Google',
                                background: Colors.white,
                                border: Colors.grey[300]!,
                                child: const Icon(Icons.g_mobiledata, size: 28),
                                onTap: () {
                                },
                              ),
                              const SizedBox(width: 12),
                              _SocialIconButton(
                                tooltip: 'Entrar com Facebook',
                                background: const Color(0xFF1877F2),
                                child: const Icon(Icons.facebook, color: Colors.white),
                                onTap: () {
                                },
                              ),
                              const SizedBox(width: 12),
                              _SocialIconButton(
                                tooltip: 'Entrar com Apple',
                                background: Colors.black,
                                child: const Icon(Icons.apple, color: Colors.white),
                                onTap: () {
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Ainda não tem conta?', style: TextStyle(color: Colors.grey[700])),
                              TextButton(
                                onPressed: () {
                                },
                                child: const Text('Criar Conta'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _softCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final String tooltip;
  final Color background;
  final Color? border;

  const _SocialIconButton({
    required this.child,
    required this.onTap,
    required this.tooltip,
    required this.background,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
            border: border != null ? Border.all(color: border!, width: 1) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
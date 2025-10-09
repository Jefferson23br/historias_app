import 'package:flutter/material.dart';
import '../core/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onControllersChanged);
    _passwordController.addListener(_onControllersChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onControllersChanged);
    _passwordController.removeListener(_onControllersChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onControllersChanged() {
    if (mounted) setState(() {});
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
                    Image.asset(
                      "assets/images/logo.png",
                      height: 120,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Mundo de Histórias',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Crie sua conta e veja a magia acontecer',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.blueAccent.shade200,
                        fontWeight: FontWeight.w600,
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
                          Center(
                            child: Text(
                              'Entrar',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          _GhostPlaceholderTextField(
                            controller: _emailController,
                            labelText: '',
                            ghostText: 'Esqueci meu email',
                            onGhostTap: _onForgotEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 12),

                          _GhostPlaceholderTextField(
                            controller: _passwordController,
                            labelText: '',
                            ghostText: 'Esqueci minha senha',
                            onGhostTap: _onForgotPassword,
                            obscureText: _isObscure,
                            keyboardType: TextInputType.text,
                            trailing: IconButton(
                              tooltip: _isObscure ? 'Mostrar senha' : 'Ocultar senha',
                              icon: Icon(
                                _isObscure ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey[600],
                              ),
                              onPressed: () => setState(() => _isObscure = !_isObscure),
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
                                onTap: () {},
                              ),
                              const SizedBox(width: 12),
                              _SocialIconButton(
                                tooltip: 'Entrar com Facebook',
                                background: const Color(0xFF1877F2),
                                child: const Icon(Icons.facebook, color: Colors.white),
                                onTap: () {},
                              ),
                              const SizedBox(width: 12),
                              _SocialIconButton(
                                tooltip: 'Entrar com Apple',
                                background: Colors.black,
                                child: const Icon(Icons.apple, color: Colors.white),
                                onTap: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Ainda não tem conta?', style: TextStyle(color: Colors.grey[700])),
                              TextButton(
                                onPressed: () {},
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

  void _onForgotEmail() {
  }

  void _onForgotPassword() {
  Navigator.pushNamed(context, '/reset-password', arguments: {
    'prefillEmail': _emailController.text.trim(),
  });
  }

  Widget _softCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _GhostPlaceholderTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String ghostText;
  final VoidCallback onGhostTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? trailing;

  const _GhostPlaceholderTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.ghostText,
    required this.onGhostTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final ghostStyle = theme.textTheme.bodyMedium?.copyWith(
      color: Colors.grey.withOpacity(0.6),
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
      shadows: const [
        Shadow(offset: Offset(0, 1), blurRadius: 1.5, color: Color(0x1A000000)),
      ],
    );

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: labelText,
            suffixIcon: trailing == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: trailing,
                  ),
          ),
        ),

        if (controller.text.isEmpty)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(
                  right: trailing == null ? 12 : 48,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: onGhostTap,
                    child: Text(
                      ghostText,
                      style: ghostStyle,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
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
        child: Container
        (
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
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../core/routes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Redirecionar para completar perfil
        Navigator.pushReplacementNamed(context, AppRoutes.completeProfile);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        _showError(_mapAuthError(e.code));
      }
    } catch (e) {
      if (mounted) {
        _showError('Erro ao criar conta. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este email já está em uso.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'weak-password':
        return 'Senha muito fraca.';
      default:
        return 'Erro de autenticação: $code';
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                Text(
                  'Bem-vindo!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Crie sua conta para começar',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu email';
                    }
                    if (!value.contains('@')) {
                      return 'Digite um email válido';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Confirmar Email
                TextFormField(
                  controller: _confirmEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirme seu email';
                    }
                    if (value != _emailController.text) {
                      return 'Os emails não coincidem';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Senha
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite sua senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Botão Criar Conta
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createAccount,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Criar Conta'),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Link para Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já tem uma conta? ',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Entrar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
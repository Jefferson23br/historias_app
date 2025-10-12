import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';s

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSending = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['prefillEmail'] is String) {
      final prefill = (args['prefillEmail'] as String).trim();
      if (prefill.isNotEmpty) {
        _emailController.text = prefill;
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnack('Informe seu email para continuar.');
      return;
    }
    setState(() => _isSending = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      _showSnack('Enviamos um email para redefinição de senha.');
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      final msg = _mapAuthError(e);
      _showSnack(msg);
    } catch (_) {
      _showSnack('Não foi possível enviar o email. Tente novamente.');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Email inválido.';
      case 'user-not-found':
        return 'Não encontramos uma conta com esse email.';
      case 'missing-email':
        return 'Informe o email.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      default:
        return 'Erro ao enviar email: ${e.message ?? e.code}';
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar senha'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Digite o email da sua conta e enviaremos um link para você redefinir sua senha.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                onSubmitted: (_) => _sendReset(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _isSending ? null : _sendReset,
                  child: _isSending
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Enviar link de redefinição'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
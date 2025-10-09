import 'package:flutter/material.dart';
import '../core/routes.dart';

class ForgotEmailPage extends StatefulWidget {
  const ForgotEmailPage({super.key});

  @override
  State<ForgotEmailPage> createState() => _ForgotEmailPageState();
}

class _ForgotEmailPageState extends State<ForgotEmailPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();

  bool _sending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  void _toResetPassword() {
    // Leva o usuário para a recuperação de senha
    Navigator.pushReplacementNamed(context, AppRoutes.resetPassword);
  }

  Future<void> _sendSupport() async {
    // Aqui você poderia integrar com Firestore, Functions, ou enviar email
    // Por enquanto só simulamos feedback visual.
    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _sending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sua solicitação foi enviada. Entraremos em contato.')),
    );
    Navigator.pop(context); // volta para o login
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Esqueci meu email')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Como tentar recuperar seu email:',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _TipItem(text: '1) Verifique em qual conta Google/Apple você costuma entrar.'),
              _TipItem(text: '2) Pesquise na sua caixa de entrada por “Mundo de Histórias” para achar emails anteriores.'),
              _TipItem(text: '3) Se você usou login social (Google/Apple/Facebook), tente entrar por lá.'),
              _TipItem(text: '4) Se lembrar parte do email, teste variações mais comuns.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _toResetPassword,
                child: const Text('Lembrei meu email — recuperar senha'),
              ),
              const SizedBox(height: 24),
              Text(
                'Ainda precisa de ajuda?',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Envie uma breve descrição e, se possível, seu nome/apelido para localizarmos sua conta.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Seu nome (opcional)',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _hintController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Conte mais detalhes (ex.: último acesso, parte do email)',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  icon: _sending
                      ? const SizedBox(
                          width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.support_agent),
                  label: Text(_sending ? 'Enviando...' : 'Enviar para suporte'),
                  onPressed: _sending ? null : _sendSupport,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;
  const _TipItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
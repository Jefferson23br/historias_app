import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/favorite_button.dart';

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;
  final String title;
  final String bookId;
  final String? pdfUrl2;

  const PdfViewerPage({
    super.key,
    required this.pdfUrl,
    required this.title,
    required this.bookId,
    this.pdfUrl2,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late String currentUrl;
  bool _isShowingTextVersion = false;
  bool _hasAccess = false;
  bool _isLoadingAccess = true;
  bool _isPremiumBook = false;

  @override
  void initState() {
    super.initState();
    currentUrl = widget.pdfUrl;
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    setState(() {
      _isLoadingAccess = true;
    });

    try {
      // Buscar dados do usuário atual
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Usuário não autenticado, negar acesso a livros premium
        _hasAccess = false;
        _isPremiumBook = false;
      } else {
        // Buscar dados do usuário no Firestore
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final userData = userDoc.data();

        // Buscar dados do livro para saber se é premium
        final bookDoc = await FirebaseFirestore.instance.collection('books').doc(widget.bookId).get();
        final bookData = bookDoc.data();

        _isPremiumBook = bookData?['isPremium'] ?? false;

        final userType = userData?['userType'] ?? 'user_basic';

        // Regras de acesso
        if (!_isPremiumBook) {
          // Livro gratuito, todos têm acesso
          _hasAccess = true;
        } else {
          // Livro premium, só user_premium e user_admin têm acesso
          if (userType == 'user_premium' || userType == 'user_admin') {
            _hasAccess = true;
          } else {
            _hasAccess = false;
          }
        }
      }
    } catch (e) {
      // Em caso de erro, negar acesso por segurança
      _hasAccess = false;
      _isPremiumBook = false;
    }

    setState(() {
      _isLoadingAccess = false;
    });

    if (!_hasAccess) {
      _showAccessDeniedDialog();
    }
  }

  void _showAccessDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Acesso Negado'),
        content: const Text('Este livro é exclusivo para assinantes.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo
              Navigator.of(context).pop(); // Volta para a tela anterior
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implementar fluxo de assinatura
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidade de assinatura em desenvolvimento')),
              );
            },
            child: const Text('Assinar'),
          ),
        ],
      ),
    );
  }

  void _switchToImageVersion() {
    setState(() {
      currentUrl = widget.pdfUrl;
      _isShowingTextVersion = false;
    });
  }

  void _switchToTextVersion() {
    if (widget.pdfUrl2 != null && widget.pdfUrl2!.isNotEmpty) {
      setState(() {
        currentUrl = widget.pdfUrl2!;
        _isShowingTextVersion = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasTextVersion = widget.pdfUrl2 != null && widget.pdfUrl2!.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            FavoriteButton(bookId: widget.bookId, size: 28),
          ],
        ),
      ),
      body: _isLoadingAccess
          ? const Center(child: CircularProgressIndicator())
          : _hasAccess
              ? Column(
                  children: [
                    // Botões de tipo de leitura com Wrap para evitar overflow
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _isShowingTextVersion ? _switchToImageVersion : null,
                            icon: const Icon(Icons.picture_as_pdf_outlined),
                            label: const Text("Leitura com Imagens"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !_isShowingTextVersion
                                  ? Colors.purple.shade300
                                  : Colors.grey.shade300,
                              foregroundColor: !_isShowingTextVersion
                                  ? Colors.white
                                  : Colors.black54,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          if (hasTextVersion)
                            ElevatedButton.icon(
                              onPressed: !_isShowingTextVersion ? _switchToTextVersion : null,
                              icon: const Icon(Icons.text_fields),
                              label: const Text("Leitura em Texto"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isShowingTextVersion
                                    ? Colors.pink.shade300
                                    : Colors.grey.shade300,
                                foregroundColor: _isShowingTextVersion
                                    ? Colors.white
                                    : Colors.black54,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    Expanded(
                      child: Container(
                        key: ValueKey(currentUrl), // ← Key no Container, não no PDF
                        child: PDF().cachedFromUrl(
                          currentUrl,
                          placeholder: (progress) =>
                              Center(child: Text('$progress %', style: const TextStyle(fontSize: 18))),
                          errorWidget: (error) =>
                              Center(child: Text('Erro ao carregar PDF: $error')),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    'Você não tem permissão para acessar este livro.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../data/models/book.dart';
import '../../data/repositories/book_repository.dart';
import '../../pages/pdf_viewer_page.dart';
import '../../widgets/app_background.dart';

class CategoryBooksPage extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryBooksPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  void _openPdf(BuildContext context, String pdfUrl, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(
          pdfUrl: pdfUrl,
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Barra superior com botão voltar pequeno
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),

              // Espaço para os livros em grid 2x4
              Expanded(
                child: StreamBuilder<List<Book>>(
                  stream: BookRepository.instance.booksByCategoryStream(categoryId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erro ao carregar livros: ${snapshot.error}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final books = snapshot.data!;
                    // Preencher até 8 posições (2 colunas x 4 linhas)
                    final displayBooks = List<Book?>.filled(8, null);
                    for (int i = 0; i < books.length && i < 8; i++) {
                      displayBooks[i] = books[i];
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.6, // altura maior que largura
                      ),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        final book = displayBooks[index];
                        if (book == null) {
                          // Placeholder vazio para manter layout
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: () => _openPdf(context, book.pdfUrl, book.title),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      book.coverUrl,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.broken_image, size: 48),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      book.title,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
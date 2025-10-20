import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/book_repository.dart';
import '../../data/repositories/category_repository.dart';
import 'widgets/book_card.dart';
import '../../data/models/book.dart';
import '../../data/models/category.dart';
import 'widgets/category_strip.dart';
import '../category_books/category_books_page.dart';
import '../../pages/pdf_viewer_page.dart';
import '../../widgets/app_background.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _openPdf(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(
          pdfUrl: book.pdfUrl,
          title: book.title,
          pdfUrl2: book.pdfUrl2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título Top 10 simplificado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Top 10',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Top 10 livros com marca d'água numérica
                StreamBuilder<List<Book>>(
                  stream: BookRepository.instance.top10Stream(),
                  builder: (context, snapshot) {
                    final books = snapshot.data ?? [];

                    // Preencher até 10 posições com null para placeholders
                    final displayBooks = List<Book?>.filled(10, null);
                    for (int i = 0; i < books.length && i < 10; i++) {
                      displayBooks[i] = books[i];
                    }

                    return SizedBox(
                      height: 220,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final book = displayBooks[index];
                          if (book == null) {
                            // Placeholder para posição sem livro
                            return SizedBox(
                              width: 140,
                              child: Center(
                                child: Text(
                                  '${index + 1}º',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }
                          return Stack(
                            children: [
                              BookCard(
                                book: book,
                                onTap: () => _openPdf(context, book),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${index + 1}º',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Seção Recomendações para você (mantida igual)
                if (uid != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Recomendações para você',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (uid != null) const SizedBox(height: 12),
                if (uid != null)
                  SizedBox(
                    height: 220,
                    child: StreamBuilder<List<Book>>(
                      stream: BookRepository.instance.recommendationsForUserStream(uid),
                      builder: (context, snapshot) {
                        final books = snapshot.data ?? [];
                        if (books.isEmpty) {
                          return const Center(child: Text('Nenhuma recomendação disponível.'));
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: books.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final book = books[index];
                            return BookCard(
                              book: book,
                              onTap: () => _openPdf(context, book),
                            );
                          },
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 24),

                // Categorias com visual moderno e infantil, agora menores (1/4 da largura)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Categorias',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                StreamBuilder<List<Category>>(
                  stream: CategoryRepository.instance.categoriesStream(),
                  builder: (context, snapshot) {
                    final categories = snapshot.data ?? [];
                    if (categories.isEmpty) {
                      return const Center(child: Text('Nenhuma categoria encontrada.'));
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: categories.map((cat) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CategoryBooksPage(
                                    categoryId: cat.id,
                                    categoryName: cat.name,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: (MediaQuery.of(context).size.width - 80) / 4, // 1/4 da largura com espaçamento
                              height: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pink.shade200,
                                    Colors.purple.shade300,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purple.shade100.withOpacity(0.6),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      cat.imageUrl,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      colorBlendMode: BlendMode.multiply,
                                      color: Colors.black.withOpacity(0.3),
                                      errorBuilder: (_, __, ___) => Container(
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.broken_image, size: 36),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      cat.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 4,
                                            color: Colors.black54,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
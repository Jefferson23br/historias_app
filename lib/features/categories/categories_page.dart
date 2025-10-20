import 'package:flutter/material.dart';
import '../../data/models/category.dart';
import '../../data/repositories/category_repository.dart';
import '../category_books/category_books_page.dart';
import '../../widgets/app_background.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: StreamBuilder<List<Category>>(
            stream: CategoryRepository.instance.categoriesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar categorias: ${snapshot.error}', style: theme.textTheme.bodyMedium));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final categories = snapshot.data!;
              if (categories.isEmpty) {
                return Center(child: Text('Nenhuma categoria encontrada.', style: theme.textTheme.bodyMedium));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
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
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            cat.imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: theme.colorScheme.onSurface.withOpacity(0.1),
                              child: const Icon(Icons.broken_image, size: 48),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Text(
                            cat.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black.withOpacity(0.7),
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
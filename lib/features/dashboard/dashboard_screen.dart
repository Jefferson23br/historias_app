import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/book_repository.dart';
import '../../data/repositories/category_repository.dart';
import 'widgets/section_horizontal.dart';
import 'widgets/book_card.dart';
import '../../data/models/book.dart';
import 'widgets/category_strip.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('Mundo de Histórias'),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
            ],
          ),

          SliverToBoxAdapter(
            child: SectionHorizontal<Book>(
              title: 'Top 10 (últimos 15 dias)',
              stream: BookRepository.instance.top10Stream(),
              itemBuilder: (book) => BookCard(
                book: book,
                onTap: () {
                  // TODO: Navegar para detalhes/leitura e registrar view/favorite
                },
              ),
            ),
          ),

          if (uid != null)
            SliverToBoxAdapter(
              child: SectionHorizontal<Book>(
                title: 'Recomendações para você',
                stream: BookRepository.instance.recommendationsForUserStream(uid),
                itemBuilder: (book) => BookCard(book: book),
              ),
            ),

          SliverToBoxAdapter(
            child: CategoryStrip(
              title: 'Categorias',
              stream: CategoryRepository.instance.categoriesStream(),
              onTapCategory: (cat) {
                // TODO: Navegar para lista filtrada por categoria
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
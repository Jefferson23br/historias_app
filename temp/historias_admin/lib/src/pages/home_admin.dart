import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'users/users_page.dart';
import 'categories/categories_page.dart';
import 'books/books_page.dart';
import 'recommendations/recommendations_page.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});
  
  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const UsersPage(),
      const CategoriesPage(),
      const BooksPage(),
      const RecommendationsPage(),
    ];
    final titles = ['Usuários', 'Categorias', 'Livros', 'Indicações'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - ${titles[index]}'),
        actions: [
          IconButton(
            onPressed: () async => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: index,
            onDestinationSelected: (i) => setState(() => index = i),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.people), label: Text('Usuários')),
              NavigationRailDestination(icon: Icon(Icons.category), label: Text('Categorias')),
              NavigationRailDestination(icon: Icon(Icons.menu_book), label: Text('Livros')),
              NavigationRailDestination(icon: Icon(Icons.star), label: Text('Indicações')),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: pages[index]),
        ],
      ),
    );
  }
}
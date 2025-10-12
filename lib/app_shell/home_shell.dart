import 'package:flutter/material.dart';
import '../features/dashboard/dashboard_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _pages = const [
    DashboardScreen(),
    _PlaceholderScreen(title: 'Lançamentos'),
    _PlaceholderScreen(title: 'Minha Lista'),
    _PlaceholderScreen(title: 'Categorias'),
    _PlaceholderScreen(title: 'Meu Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Tela Inicial'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'Lançamentos'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_rounded), label: 'Minha Lista'),
          BottomNavigationBarItem(icon: Icon(Icons.category_rounded), label: 'Categorias'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Meu Perfil'),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title em breve')),
    );
  }
}
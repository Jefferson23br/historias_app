import 'package:flutter/material.dart';
import '../../../data/models/category.dart';

class CategoryStrip extends StatelessWidget {
  final String title;
  final Stream<List<Category>> stream;
  final void Function(Category) onTapCategory;

  const CategoryStrip({
    super.key,
    required this.title,
    required this.stream,
    required this.onTapCategory,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(title, style: titleStyle),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: StreamBuilder<List<Category>>(
              stream: stream,
              builder: (context, snap) {
                final cats = snap.data ?? [];
                if (cats.isEmpty) {
                  return const Center(child: Text('Sem categorias'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: cats.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => ActionChip(
                    label: Text(cats[i].name),
                    onPressed: () => onTapCategory(cats[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
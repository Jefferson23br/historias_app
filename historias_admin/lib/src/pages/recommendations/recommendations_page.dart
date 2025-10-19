import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  final db = FirebaseFirestore.instance;
  List<String> ids = [];
  bool loading = true;
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final doc = await db.collection('settings').doc('recommendations').get();
    ids = List<String>.from((doc.data() ?? {})['bookIds'] ?? const []);
    setState(() => loading = false);
  }

  Future<void> _save() async {
    await db.collection('settings').doc('recommendations').set({
      'bookIds': ids.take(10).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Indicações salvas.')));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 320,
                child: TextField(
                  controller: searchCtrl,
                  decoration: const InputDecoration(labelText: 'Buscar livro por nome'),
                  onSubmitted: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _save, child: const Text('Salvar')),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                // Busca
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Resultados'),
                      const SizedBox(height: 8),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: db.collection('books')
                            .where('name', isGreaterThanOrEqualTo: searchCtrl.text.trim().isEmpty ? '\u{10FFFF}' : searchCtrl.text.trim())
                            .limit(20).snapshots(),
                          builder: (_, snap) {
                            if (!snap.hasData) return const Center(child: Text('Digite e pressione Enter'));
                            final docs = snap.data!.docs;
                            return ListView.builder(
                              itemCount: docs.length,
                              itemBuilder: (_, i) {
                                final d = docs[i];
                                final m = d.data() as Map<String, dynamic>;
                                return ListTile(
                                  leading: SizedBox(width: 40, height: 56, child: (m['coverUrl'] ?? '').toString().isNotEmpty
                                    ? Image.network(m['coverUrl'], fit: BoxFit.cover)
                                    : const ColoredBox(color: Color(0xFFE0E0E0))),
                                  title: Text(m['name'] ?? ''),
                                  subtitle: Text('cat: ${m['categoryId'] ?? ''}  •  ${(m['premium'] ?? false) ? 'Premium' : 'Grátis'}'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        if (!ids.contains(d.id) && ids.length < 10) ids.add(d.id);
                                      });
                                    },
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

                const VerticalDivider(width: 1),

                // Selecionados (ordenável)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selecionados (máx 10)'),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ReorderableListView(
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) newIndex -= 1;
                              final item = ids.removeAt(oldIndex);
                              ids.insert(newIndex, item);
                            });
                          },
                          children: [
                            for (final id in ids)
                              Dismissible(
                                key: ValueKey(id),
                                background: Container(color: Colors.redAccent),
                                onDismissed: (_) => setState(() => ids.remove(id)),
                                child: ListTile(
                                  key: ValueKey('tile_$id'),
                                  leading: const Icon(Icons.drag_handle),
                                  title: Text(id),
                                  subtitle: const Text('Arraste para reordenar. Remova deslizando.'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
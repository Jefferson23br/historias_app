import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Novo Livro'),
                onPressed: () => showDialog(context: context, builder: (_) => const _BookDialog()),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: db.collection('books').orderBy('name').snapshots(),
              builder: (_, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Capa')),
                      DataColumn(label: Text('Nome')),
                      DataColumn(label: Text('Categoria')),
                      DataColumn(label: Text('Premium')),
                      DataColumn(label: Text('Conteúdo URL')),
                      DataColumn(label: Text('Ações')),
                    ],
                    rows: docs.map((d) {
                      final m = d.data() as Map<String, dynamic>;
                      return DataRow(cells: [
                        DataCell(SizedBox(width: 60, height: 80, child: m['coverUrl'] != null && (m['coverUrl'] as String).isNotEmpty
                          ? Image.network(m['coverUrl'], fit: BoxFit.cover)
                          : const ColoredBox(color: Color(0xFFE0E0E0)))),
                        DataCell(Text(m['name'] ?? '')),
                        DataCell(Text(m['categoryId'] ?? '')),
                        DataCell(Icon((m['premium'] ?? false) ? Icons.lock : Icons.lock_open)),
                        DataCell(Text(m['contentUrl'] ?? '')),
                        DataCell(Row(
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => showDialog(context: context, builder: (_) => _BookDialog(id: d.id, data: m))),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () async {
                              final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
                                title: const Text('Excluir livro?'),
                                content: Text(m['name'] ?? ''),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                                  ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
                                ],
                              )) ?? false;
                              if (ok) await db.collection('books').doc(d.id).delete();
                            }),
                          ],
                        )),
                      ]);
                    }).toList(),
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

class _BookDialog extends StatefulWidget {
  final String? id;
  final Map<String, dynamic>? data;
  const _BookDialog({this.id, this.data});

  @override
  State<_BookDialog> createState() => _BookDialogState();
}

class _BookDialogState extends State<_BookDialog> {
  final name = TextEditingController();
  final coverUrl = TextEditingController();
  final contentUrl = TextEditingController();
  String? categoryId;
  bool premium = false;

  @override
  void initState() {
    super.initState();
    final d = widget.data;
    if (d != null) {
      name.text = d['name'] ?? '';
      coverUrl.text = d['coverUrl'] ?? '';
      contentUrl.text = d['contentUrl'] ?? '';
      categoryId = d['categoryId'];
      premium = d['premium'] ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    return AlertDialog(
      title: Text(widget.id == null ? 'Novo Livro' : 'Editar Livro'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: 'Nome')),
              TextField(controller: coverUrl, decoration: const InputDecoration(labelText: 'Capa (URL)')),
              TextField(controller: contentUrl, decoration: const InputDecoration(labelText: 'Conteúdo (URL)')),
              const SizedBox(height: 8),
              StreamBuilder<QuerySnapshot>(
                stream: db.collection('categories').orderBy('name').snapshots(),
                builder: (_, snap) {
                  final items = (snap.data?.docs ?? []).map((d) => DropdownMenuItem<String>(
                    value: d.id, child: Text((d.data() as Map<String, dynamic>)['name'] ?? ''),
                  )).toList();
                  return DropdownButtonFormField<String>(
                    value: categoryId,
                    items: items,
                    onChanged: (v) => setState(() => categoryId = v),
                    decoration: const InputDecoration(labelText: 'Categoria'),
                  );
                },
              ),
              SwitchListTile(
                value: premium,
                onChanged: (v) => setState(() => premium = v),
                title: const Text('Premium (bloqueado para não assinantes)'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () async {
            if ((name.text.trim().isEmpty) || (categoryId == null)) return;
            final data = {
              'name': name.text.trim(),
              'coverUrl': coverUrl.text.trim(),
              'contentUrl': contentUrl.text.trim(),
              'categoryId': categoryId,
              'premium': premium,
              'title': name.text.trim(),         // compatibilidade com app (se precisar)
              'updatedAt': FieldValue.serverTimestamp(),
              if (widget.id == null) 'createdAt': FieldValue.serverTimestamp(),
            };
            if (widget.id == null) {
              await db.collection('books').add(data);
            } else {
              await db.collection('books').doc(widget.id).set(data, SetOptions(merge: true));
            }
            if (!mounted) return;
            Navigator.pop(context);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
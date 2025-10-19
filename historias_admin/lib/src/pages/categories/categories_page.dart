import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final nameCtrl = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 260,
                child: TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nova categoria')),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  final name = nameCtrl.text.trim();
                  if (name.isEmpty) return;
                  await db.collection('categories').add({
                    'name': name,
                    'createdAt': FieldValue.serverTimestamp(),
                    'updatedAt': FieldValue.serverTimestamp(),
                  });
                  nameCtrl.clear();
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: db.collection('categories').orderBy('name').snapshots(),
              builder: (_, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final d = docs[i];
                    final m = d.data() as Map<String, dynamic>;
                    final ctrl = TextEditingController(text: m['name'] ?? '');
                    return ListTile(
                      title: TextField(
                        controller: ctrl,
                        decoration: const InputDecoration(border: InputBorder.none),
                        onSubmitted: (v) => db.collection('categories').doc(d.id).set({
                          'name': v.trim(),
                          'updatedAt': FieldValue.serverTimestamp(),
                        }, SetOptions(merge: true)),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
                            title: const Text('Excluir categoria?'),
                            content: Text(m['name'] ?? ''),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                              ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
                            ],
                          )) ?? false;
                          if (ok) await db.collection('categories').doc(d.id).delete();
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
    );
  }
}
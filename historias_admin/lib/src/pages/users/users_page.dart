import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/admin_auth_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _service = AdminAuthService();
  final _items = <Map<String, dynamic>>[];
  String? _nextToken;
  bool _loading = false;
  bool _initialLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  Future<void> _loadMore() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final res = await _service.listUsers(pageSize: 50, pageToken: _nextToken);
      setState(() {
        _items.addAll(res.users);
        _nextToken = res.nextPageToken;
        _initialLoaded = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao listar usuários: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _showCreateDialog() async {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    String role = 'user_free';

    final created = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Criar usuário'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nome (opcional)')),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: role,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: const [
                    DropdownMenuItem(value: 'user_free', child: Text('Usuário Free')),
                    DropdownMenuItem(value: 'user_premium', child: Text('Usuário Premium')),
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  ],
                  onChanged: (v) => role = v ?? 'user_free',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Criar')),
          ],
        );
      },
    );

    if (created != true) return;

    try {
      final uid = await _service.createUser(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
        displayName: nameCtrl.text.trim().isEmpty ? null : nameCtrl.text.trim(),
        role: role,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário criado! UID: $uid')),
      );
      // Recarrega a lista do zero
      setState(() {
        _items.clear();
        _nextToken = null;
        _initialLoaded = false;
      });
      await _loadMore();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar usuário: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialLoaded && _loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários (Authentication)'),
        actions: [
          IconButton(
            onPressed: _loading ? null : () {
              setState(() {
                _items.clear();
                _nextToken = null;
                _initialLoaded = false;
              });
              _loadMore();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Recarregar',
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        icon: const Icon(Icons.person_add),
        label: const Text('Novo usuário'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final u = _items[i];
                final claims = Map<String, dynamic>.from(u['customClaims'] ?? {});
                final role = claims['role'] ?? 'user_free';
                final email = u['email'] ?? '';
                final name = u['displayName'] ?? '';
                final disabled = u['disabled'] == true;
                final creation = u['metadata']?['creationTime'];
                final lastSignIn = u['metadata']?['lastSignInTime'];

                String fmt(String? iso) {
                  if (iso == null) return '-';
                  final dt = DateTime.tryParse(iso);
                  if (dt == null) return iso;
                  return DateFormat('dd/MM/yyyy HH:mm').format(dt);
                }

                return ListTile(
                  title: Text(name.isNotEmpty ? '$name ($email)' : (email.isNotEmpty ? email : u['uid'])),
                  subtitle: Text('Role: $role • UID: ${u['uid']}\nCriado: ${fmt(creation)} • Último login: ${fmt(lastSignIn)}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (disabled)
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.do_not_disturb_on, color: Colors.red),
                        ),
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          try {
                            if (value.startsWith('role:')) {
                              final newRole = value.split(':')[1];
                              await _service.setUserRole(u['uid'], newRole);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Role alterada para $newRole')));
                            } else if (value == 'toggle-disable') {
                              await _service.setUserDisabled(u['uid'], !disabled);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(disabled ? 'Usuário ativado' : 'Usuário desativado')));
                            } else if (value == 'delete') {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Confirmar exclusão'),
                                  content: Text('Excluir o usuário ${email.isNotEmpty ? email : u['uid']}? Esta ação não pode ser desfeita.'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                                    ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
                                  ],
                                ),
                              );
                              if (ok == true) {
                                await _service.deleteUser(u['uid']);
                                setState(() {
                                  _items.removeAt(i);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário excluído')));
                              }
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'role:user_free', child: Text('Tornar Free')),
                          const PopupMenuItem(value: 'role:user_premium', child: Text('Tornar Premium')),
                          const PopupMenuItem(value: 'role:admin', child: Text('Tornar Admin')),
                          const PopupMenuDivider(),
                          PopupMenuItem(value: 'toggle-disable', child: Text(disabled ? 'Ativar' : 'Desativar')),
                          const PopupMenuDivider(),
                          const PopupMenuItem(value: 'delete', child: Text('Excluir usuário')),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_nextToken != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: _loading ? null : _loadMore,
                child: _loading ? const CircularProgressIndicator() : const Text('Carregar mais'),
              ),
            ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../services/auth_service.dart';
import '../core/routes.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  
  // Controllers
  final _nomeController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  
  // Máscaras
  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  
  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  
  String _selectedEstado = 'SP';
  String _selectedPais = 'Brasil';
  bool _isLoading = false;
  bool _canSkip = false;

  // Estados brasileiros
  final List<String> _estados = [
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA',
    'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN',
    'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO', 'EX'
  ];

  // Países (lista simplificada)
  final List<String> _paises = [
    'Brasil', 'Argentina', 'Chile', 'Colômbia', 'Estados Unidos',
    'Portugal', 'Espanha', 'França', 'Alemanha', 'Itália',
    'Reino Unido', 'Canadá', 'México', 'Outro'
  ];

  @override
  void initState() {
    super.initState();
    _checkIfCanSkip();
  }

  void _checkIfCanSkip() {
    // Permitir pular apenas na primeira vez (após cadastro)
    // Você pode adicionar lógica adicional aqui
    setState(() => _canSkip = true);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = _authService.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    final result = await _authService.updateUserProfile(
      uid: user.uid,
      data: {
        'nomeCompleto': _nomeController.text.trim(),
        'rua': _ruaController.text.trim(),
        'numero': _numeroController.text.trim(),
        'complemento': _complementoController.text.trim(),
        'bairro': _bairroController.text.trim(),
        'cidade': _cidadeController.text.trim(),
        'estado': _selectedEstado,
        'pais': _selectedPais,
        'cpf': _cpfController.text.trim(),
        'telefone': _telefoneController.text.trim(),
      },
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _skipForNow() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pular cadastro?'),
        content: const Text(
          'Você pode completar seu perfil depois nas configurações. '
          'Algumas funcionalidades podem estar limitadas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
            child: const Text('Pular'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete seu Perfil'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          if (_canSkip)
            TextButton(
              onPressed: _skipForNow,
              child: const Text('Pular'),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Complete suas informações',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Precisamos de alguns dados para melhorar sua experiência',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Nome Completo
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome Completo *',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu nome completo';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Rua
                TextFormField(
                  controller: _ruaController,
                  decoration: const InputDecoration(
                    labelText: 'Rua *',
                    prefixIcon: Icon(Icons.home),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite sua rua';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Número e Complemento
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _numeroController,
                        decoration: const InputDecoration(
                          labelText: 'Número *',
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Número';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _complementoController,
                        decoration: const InputDecoration(
                          labelText: 'Complemento',
                          prefixIcon: Icon(Icons.apartment),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Bairro
                TextFormField(
                  controller: _bairroController,
                  decoration: const InputDecoration(
                    labelText: 'Bairro *',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu bairro';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Cidade
                TextFormField(
                  controller: _cidadeController,
                  decoration: const InputDecoration(
                    labelText: 'Cidade *',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite sua cidade';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Estado
                DropdownButtonFormField<String>(
                  value: _selectedEstado,
                  decoration: const InputDecoration(
                    labelText: 'Estado *',
                    prefixIcon: Icon(Icons.map),
                  ),
                  items: _estados.map((estado) {
                    return DropdownMenuItem(
                      value: estado,
                      child: Text(estado == 'EX' ? 'Estrangeiro' : estado),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedEstado = value!);
                  },
                ),
                
                const SizedBox(height: 16),
                
                // País
                DropdownButtonFormField<String>(
                  value: _selectedPais,
                  decoration: const InputDecoration(
                    labelText: 'País *',
                    prefixIcon: Icon(Icons.public),
                  ),
                  items: _paises.map((pais) {
                    return DropdownMenuItem(
                      value: pais,
                      child: Text(pais),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedPais = value!);
                  },
                ),
                
                const SizedBox(height: 16),
                
                // CPF
                TextFormField(
                  controller: _cpfController,
                  inputFormatters: [_cpfMask],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'CPF *',
                    prefixIcon: Icon(Icons.badge),
                    hintText: '000.000.000-00',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu CPF';
                    }
                    if (value.length < 14) {
                      return 'CPF inválido';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Telefone
                TextFormField(
                  controller: _telefoneController,
                  inputFormatters: [_telefoneMask],
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telefone *',
                    prefixIcon: Icon(Icons.phone),
                    hintText: '(00) 00000-0000',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite seu telefone';
                    }
                    if (value.length < 15) {
                      return 'Telefone inválido';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Botão Salvar
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Salvar e Continuar'),
                  ),
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
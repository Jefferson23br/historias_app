class UserModel {
  final String uid;
  final String email;
  final String? nomeCompleto;
  final String? rua;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String? cidade;
  final String? estado;
  final String? pais;
  final String? cpf;
  final String? telefone;
  final String userType; // Cliente, Assinante, Administrador
  final bool profileCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    this.nomeCompleto,
    this.rua,
    this.numero,
    this.complemento,
    this.bairro,
    this.cidade,
    this.estado,
    this.pais = 'Brasil',
    this.cpf,
    this.telefone,
    this.userType = 'Cliente',
    this.profileCompleted = false,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nomeCompleto': nomeCompleto,
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'pais': pais,
      'cpf': cpf,
      'telefone': telefone,
      'userType': userType,
      'profileCompleted': profileCompleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      nomeCompleto: map['nomeCompleto'],
      rua: map['rua'],
      numero: map['numero'],
      complemento: map['complemento'],
      bairro: map['bairro'],
      cidade: map['cidade'],
      estado: map['estado'],
      pais: map['pais'] ?? 'Brasil',
      cpf: map['cpf'],
      telefone: map['telefone'],
      userType: map['userType'] ?? 'Cliente',
      profileCompleted: map['profileCompleted'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? nomeCompleto,
    String? rua,
    String? numero,
    String? complemento,
    String? bairro,
    String? cidade,
    String? estado,
    String? pais,
    String? cpf,
    String? telefone,
    String? userType,
    bool? profileCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      rua: rua ?? this.rua,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      pais: pais ?? this.pais,
      cpf: cpf ?? this.cpf,
      telefone: telefone ?? this.telefone,
      userType: userType ?? this.userType,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
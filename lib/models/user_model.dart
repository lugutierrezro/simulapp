class UserModel {
  final String id;
  final String code;
  final String fullName;
  final String dni;
  final String phone;
  final String entity; // e.g. INDECI, Bomberos, Cruz Roja, Ejercito
  final String role; // Brigadista, Evaluador EDAN, Líder de Cuadrilla
  final String teamGroup; // Cuadrilla Alfa-1, Beta-2, etc.
  final String assignedSector; // Sector 04 - Villa El Salvador - Zona R-1
  final String token;
  final bool isLoggedIn;

  UserModel({
    required this.id,
    required this.code,
    required this.fullName,
    required this.dni,
    required this.phone,
    required this.entity,
    required this.role,
    required this.teamGroup,
    required this.assignedSector,
    required this.token,
    this.isLoggedIn = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'fullName': fullName,
        'dni': dni,
        'phone': phone,
        'entity': entity,
        'role': role,
        'teamGroup': teamGroup,
        'assignedSector': assignedSector,
        'token': token,
        'isLoggedIn': isLoggedIn,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        code: json['code'] ?? '',
        fullName: json['fullName'] ?? '',
        dni: json['dni'] ?? '',
        phone: json['phone'] ?? '',
        entity: json['entity'] ?? '',
        role: json['role'] ?? '',
        teamGroup: json['teamGroup'] ?? '',
        assignedSector: json['assignedSector'] ?? '',
        token: json['token'] ?? '',
        isLoggedIn: json['isLoggedIn'] ?? false,
      );

  static UserModel mockDefault() {
    return UserModel(
      id: 'BRIG-2026-089',
      code: 'AGENTE-884',
      fullName: 'Carlos Mendoza Ruiz',
      dni: '45892011',
      phone: '+51 987 654 321',
      entity: 'Defensa Civil / INDECI',
      role: 'Brigadista Evaluador',
      teamGroup: 'Cuadrilla Respuesta Alfa-1',
      assignedSector: 'Sector 04 - Zona Crítica R-1 (Chorillos - Costa)',
      token: 'SEC_TOKEN_88492011_2026_EDAN',
      isLoggedIn: true,
    );
  }
}

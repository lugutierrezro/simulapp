class EdanChecklistModel {
  final String id;
  final String timestamp;
  final String sector;
  final String agentId;
  final String agentName;

  // Infraestructura
  final String habitabilidadStatus; // Habitable, Acceso Restringido, Inhabitable
  final bool tieneColapsoParcial;
  final bool tieneGrietasGraves;
  final bool riesgoDerrumbeSecundario;

  // Servicios Básicos
  final bool tieneAguaPotable;
  final bool tieneEnergiaElectrica;
  final bool tieneFugaGas;
  final bool tieneTelecomunicaciones;

  // Accesibilidad y Vías
  final bool viaPrincipalBloqueada;
  final bool accesoVehiculoRescate;
  final bool puenteOInfraestructuraDanada;

  // Impacto en Personas
  final int estimacionHeridos;
  final int estimacionDamnificados;
  final bool requiereEvacuacionUrgente;

  final String observacionesGenerales;
  bool isSynced;

  EdanChecklistModel({
    required this.id,
    required this.timestamp,
    required this.sector,
    required this.agentId,
    required this.agentName,
    required this.habitabilidadStatus,
    required this.tieneColapsoParcial,
    required this.tieneGrietasGraves,
    required this.riesgoDerrumbeSecundario,
    required this.tieneAguaPotable,
    required this.tieneEnergiaElectrica,
    required this.tieneFugaGas,
    required this.tieneTelecomunicaciones,
    required this.viaPrincipalBloqueada,
    required this.accesoVehiculoRescate,
    required this.puenteOInfraestructuraDanada,
    required this.estimacionHeridos,
    required this.estimacionDamnificados,
    required this.requiereEvacuacionUrgente,
    required this.observacionesGenerales,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp,
        'sector': sector,
        'agentId': agentId,
        'agentName': agentName,
        'habitabilidadStatus': habitabilidadStatus,
        'tieneColapsoParcial': tieneColapsoParcial,
        'tieneGrietasGraves': tieneGrietasGraves,
        'riesgoDerrumbeSecundario': riesgoDerrumbeSecundario,
        'tieneAguaPotable': tieneAguaPotable,
        'tieneEnergiaElectrica': tieneEnergiaElectrica,
        'tieneFugaGas': tieneFugaGas,
        'tieneTelecomunicaciones': tieneTelecomunicaciones,
        'viaPrincipalBloqueada': viaPrincipalBloqueada,
        'accesoVehiculoRescate': accesoVehiculoRescate,
        'puenteOInfraestructuraDanada': puenteOInfraestructuraDanada,
        'estimacionHeridos': estimacionHeridos,
        'estimacionDamnificados': estimacionDamnificados,
        'requiereEvacuacionUrgente': requiereEvacuacionUrgente,
        'observacionesGenerales': observacionesGenerales,
        'isSynced': isSynced,
      };

  factory EdanChecklistModel.fromJson(Map<String, dynamic> json) => EdanChecklistModel(
        id: json['id'] ?? '',
        timestamp: json['timestamp'] ?? '',
        sector: json['sector'] ?? '',
        agentId: json['agentId'] ?? '',
        agentName: json['agentName'] ?? '',
        habitabilidadStatus: json['habitabilidadStatus'] ?? 'Acceso Restringido',
        tieneColapsoParcial: json['tieneColapsoParcial'] ?? false,
        tieneGrietasGraves: json['tieneGrietasGraves'] ?? false,
        riesgoDerrumbeSecundario: json['riesgoDerrumbeSecundario'] ?? false,
        tieneAguaPotable: json['tieneAguaPotable'] ?? true,
        tieneEnergiaElectrica: json['tieneEnergiaElectrica'] ?? false,
        tieneFugaGas: json['tieneFugaGas'] ?? false,
        tieneTelecomunicaciones: json['tieneTelecomunicaciones'] ?? true,
        viaPrincipalBloqueada: json['viaPrincipalBloqueada'] ?? false,
        accesoVehiculoRescate: json['accesoVehiculoRescate'] ?? true,
        puenteOInfraestructuraDanada: json['puenteOInfraestructuraDanada'] ?? false,
        estimacionHeridos: json['estimacionHeridos'] ?? 0,
        estimacionDamnificados: json['estimacionDamnificados'] ?? 0,
        requiereEvacuacionUrgente: json['requiereEvacuacionUrgente'] ?? false,
        observacionesGenerales: json['observacionesGenerales'] ?? '',
        isSynced: json['isSynced'] ?? false,
      );
}

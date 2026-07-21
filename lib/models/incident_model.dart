class IncidentModel {
  final String id;
  final String title;
  final String category;
  final String severity; // Baja, Media, Alta, Crítica
  String status; // Registrada, En espera, Sincronizada, En atención, Atendida, Desestimada
  final String? photoPath;
  final String? watermarkInfo;
  final double latitude;
  final double longitude;
  final double accuracyMeters;
  final String sectorReference;
  final String agentId;
  final String agentName;
  final String timestamp;
  final String formVersion;
  final String tacticalNotes;
  final String requiredSupport;
  int syncAttempts;
  bool isSynced;

  IncidentModel({
    required this.id,
    required this.title,
    required this.category,
    required this.severity,
    required this.status,
    this.photoPath,
    this.watermarkInfo,
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.sectorReference,
    required this.agentId,
    required this.agentName,
    required this.timestamp,
    this.formVersion = 'EDAN-v2026.1',
    required this.tacticalNotes,
    this.requiredSupport = 'Ninguno',
    this.syncAttempts = 0,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'severity': severity,
        'status': status,
        'photoPath': photoPath,
        'watermarkInfo': watermarkInfo,
        'latitude': latitude,
        'longitude': longitude,
        'accuracyMeters': accuracyMeters,
        'sectorReference': sectorReference,
        'agentId': agentId,
        'agentName': agentName,
        'timestamp': timestamp,
        'formVersion': formVersion,
        'tacticalNotes': tacticalNotes,
        'requiredSupport': requiredSupport,
        'syncAttempts': syncAttempts,
        'isSynced': isSynced,
      };

  factory IncidentModel.fromJson(Map<String, dynamic> json) => IncidentModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        category: json['category'] ?? 'General',
        severity: json['severity'] ?? 'Media',
        status: json['status'] ?? 'En espera',
        photoPath: json['photoPath'],
        watermarkInfo: json['watermarkInfo'],
        latitude: (json['latitude'] as num?)?.toDouble() ?? -12.046374,
        longitude: (json['longitude'] as num?)?.toDouble() ?? -77.042793,
        accuracyMeters: (json['accuracyMeters'] as num?)?.toDouble() ?? 3.5,
        sectorReference: json['sectorReference'] ?? 'Sector 04',
        agentId: json['agentId'] ?? '',
        agentName: json['agentName'] ?? '',
        timestamp: json['timestamp'] ?? DateTime.now().toIso8601String(),
        formVersion: json['formVersion'] ?? 'EDAN-v2026.1',
        tacticalNotes: json['tacticalNotes'] ?? '',
        requiredSupport: json['requiredSupport'] ?? 'Ninguno',
        syncAttempts: json['syncAttempts'] ?? 0,
        isSynced: json['isSynced'] ?? false,
      );
}

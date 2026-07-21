class SupplyRequestModel {
  final String id;
  final String itemCategory; // Kits de Rescate, Agua Potable, Herramientas, Primeros Auxilios, Viveres
  final String itemName;
  final int quantityRequested;
  final String unit; // Cajas, Litros, Unidades, Botiquines
  final String priorityLevel; // Normal, Urgente, Crítico
  final String sector;
  final String timestamp;
  final String agentName;
  bool isSynced;

  SupplyRequestModel({
    required this.id,
    required this.itemCategory,
    required this.itemName,
    required this.quantityRequested,
    required this.unit,
    required this.priorityLevel,
    required this.sector,
    required this.timestamp,
    required this.agentName,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'itemCategory': itemCategory,
        'itemName': itemName,
        'quantityRequested': quantityRequested,
        'unit': unit,
        'priorityLevel': priorityLevel,
        'sector': sector,
        'timestamp': timestamp,
        'agentName': agentName,
        'isSynced': isSynced,
      };

  factory SupplyRequestModel.fromJson(Map<String, dynamic> json) => SupplyRequestModel(
        id: json['id'] ?? '',
        itemCategory: json['itemCategory'] ?? 'General',
        itemName: json['itemName'] ?? '',
        quantityRequested: json['quantityRequested'] ?? 1,
        unit: json['unit'] ?? 'Unidades',
        priorityLevel: json['priorityLevel'] ?? 'Normal',
        sector: json['sector'] ?? '',
        timestamp: json['timestamp'] ?? '',
        agentName: json['agentName'] ?? '',
        isSynced: json['isSynced'] ?? false,
      );
}

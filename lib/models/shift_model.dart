class ShiftReportModel {
  final String id;
  final String agentId;
  final String agentName;
  final String sector;
  final String startTime;
  final String endTime;
  final int totalIncidentsReported;
  final int totalEdanChecklists;
  final int totalSupplyRequests;
  final String generalObservations;
  final String teamHealthStatus;
  final bool isSynced;

  ShiftReportModel({
    required this.id,
    required this.agentId,
    required this.agentName,
    required this.sector,
    required this.startTime,
    required this.endTime,
    required this.totalIncidentsReported,
    required this.totalEdanChecklists,
    required this.totalSupplyRequests,
    required this.generalObservations,
    required this.teamHealthStatus,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'agentId': agentId,
        'agentName': agentName,
        'sector': sector,
        'startTime': startTime,
        'endTime': endTime,
        'totalIncidentsReported': totalIncidentsReported,
        'totalEdanChecklists': totalEdanChecklists,
        'totalSupplyRequests': totalSupplyRequests,
        'generalObservations': generalObservations,
        'teamHealthStatus': teamHealthStatus,
        'isSynced': isSynced,
      };

  factory ShiftReportModel.fromJson(Map<String, dynamic> json) => ShiftReportModel(
        id: json['id'] ?? '',
        agentId: json['agentId'] ?? '',
        agentName: json['agentName'] ?? '',
        sector: json['sector'] ?? '',
        startTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '',
        totalIncidentsReported: json['totalIncidentsReported'] ?? 0,
        totalEdanChecklists: json['totalEdanChecklists'] ?? 0,
        totalSupplyRequests: json['totalSupplyRequests'] ?? 0,
        generalObservations: json['generalObservations'] ?? '',
        teamHealthStatus: json['teamHealthStatus'] ?? 'Óptimo',
        isSynced: json['isSynced'] ?? false,
      );
}

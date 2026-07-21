import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/status_badge.dart';

class IncidentDetailScreen extends StatelessWidget {
  final String incidentId;

  const IncidentDetailScreen({super.key, required this.incidentId});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final incidentIdx = state.incidents.indexWhere((i) => i.id == incidentId);

    if (incidentIdx == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle de Incidencia')),
        body: const Center(child: Text('Incidencia no encontrada')),
      );
    }

    final incident = state.incidents[incidentIdx];

    return Scaffold(
      appBar: AppBar(
        title: Text('Incidencia ${incident.id}'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SeverityBadge(severity: incident.severity),
                        StatusBadge(status: incident.status, isSynced: incident.isSynced),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      incident.title,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Categoría: ${incident.category} | Formulario: ${incident.formVersion}',
                      style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Traceability Audit Info (RNF06)
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'REGISTRO DE TRAZABILIDAD E AUDITORÍA (RNF06)',
                      style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    _buildRow('ID Agente:', '${incident.agentName} (${incident.agentId})'),
                    _buildRow('Timestamp:', incident.timestamp.replaceAll('T', ' ').substring(0, 19)),
                    _buildRow('Coordenadas GPS:', '${incident.latitude}, ${incident.longitude} (±${incident.accuracyMeters}m)'),
                    _buildRow('Sector:', incident.sectorReference),
                    _buildRow('Reintentos Sync:', '${incident.syncAttempts} intentos'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Watermarked Photo Preview
            if (incident.watermarkInfo != null) ...[
              const Text(
                'EVIDENCIA FOTOGRÁFICA REGISTRADA (RF09)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.camera_alt, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          incident.photoPath ?? 'Foto Adjunta',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      color: Colors.black,
                      child: Text(
                        incident.watermarkInfo!,
                        style: const TextStyle(color: Color(0xFF4ADE80), fontFamily: 'monospace', fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Update Status Actions (RF11)
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ACTUALIZAR ESTADO DE LA INCIDENCIA (RF11)',
                      style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['En atención', 'Atendida', 'Desestimada'].map((newStatus) {
                        return ElevatedButton(
                          onPressed: () {
                            state.updateIncidentStatus(incident.id, newStatus);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Estado actualizado a $newStatus')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(newStatus),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

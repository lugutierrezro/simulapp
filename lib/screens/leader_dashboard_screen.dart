import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/status_badge.dart';

class LeaderDashboardScreen extends StatelessWidget {
  const LeaderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    final totalIncidents = state.incidents.length;
    final criticalCount = state.incidents.where((i) => i.severity.toLowerCase().contains('crítica')).length;
    final syncedCount = state.incidents.where((i) => i.isSynced).length;
    final pendingCount = state.pendingSyncCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Líder Cuadrilla (Avanzado)'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)]),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.supervisor_account, color: Color(0xFFF59E0B), size: 28),
                      SizedBox(width: 10),
                      Text(
                        'PANEL DE CONTROL DE CUADRILLA ALFA-1',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Monitoreo en tiempo real de brigadistas desplegados, incidencias críticas y resiliencia offline.',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Metrics Grid
            Row(
              children: [
                _buildCardMetric('INCIDENCIAS TOTALES', '$totalIncidents', Colors.blue, Icons.assignment),
                _buildCardMetric('ALERTAS CRÍTICAS', '$criticalCount', Colors.red, Icons.warning),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildCardMetric('PAQUETES SYNCED', '$syncedCount', Colors.green, Icons.cloud_done),
                _buildCardMetric('COLA OFFLINE', '$pendingCount', Colors.amber, Icons.cloud_off),
              ],
            ),

            const SizedBox(height: 20),
            const Text(
              'ESTADO DEL PERSONAL DE BRIGADA EN CAMPO',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),

            _buildBrigadistaCard('Carlos Mendoza (Usted)', 'AGENTE-884', 'Sector 04 - Zona R-1', 'DESPLEGADO (02:15 hrs)', Colors.green),
            _buildBrigadistaCard('Maria Fernandez', 'AGENTE-885', 'Sector 04 - Zona R-2', 'DESPLEGADO (01:40 hrs)', Colors.green),
            _buildBrigadistaCard('Jorge Ramos', 'AGENTE-886', 'Base Puesto Mando', 'EN REPOSO / LOGÍSTICA', Colors.blue),

            const SizedBox(height: 20),
            const Text(
              'ALERTAS RECIENTES DE ALTA SEVERIDAD',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),

            ...state.incidents.where((i) => i.severity.toLowerCase().contains('alta') || i.severity.toLowerCase().contains('crítica')).map((inc) {
              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.error, color: Colors.red),
                  title: Text(inc.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('Agente: ${inc.agentName} | GPS: ${inc.latitude}, ${inc.longitude}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  trailing: SeverityBadge(severity: inc.severity),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardMetric(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 9)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrigadistaCard(String name, String code, String sector, String status, Color color) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.person, color: color),
        ),
        title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text('$code • $sector', style: const TextStyle(color: Colors.white70, fontSize: 11)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(status, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

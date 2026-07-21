import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/shift_model.dart';

class ShiftClosureScreen extends StatefulWidget {
  const ShiftClosureScreen({super.key});

  @override
  State<ShiftClosureScreen> createState() => _ShiftClosureScreenState();
}

class _ShiftClosureScreenState extends State<ShiftClosureScreen> {
  final _obsCtrl = TextEditingController(text: 'Operativo concluido sin bajas en el personal. Se cubrió el 100% de la zona R-1 asignada.');
  String _teamHealth = 'Óptimo (Sin Novedad)';

  void _closeShift() async {
    final state = Provider.of<AppState>(context, listen: false);
    final user = state.currentUser!;

    final id = 'TURNO-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final shift = ShiftReportModel(
      id: id,
      agentId: user.code,
      agentName: user.fullName,
      sector: user.assignedSector,
      startTime: state.deploymentStartTime?.toIso8601String() ?? DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
      endTime: DateTime.now().toIso8601String(),
      totalIncidentsReported: state.incidents.length,
      totalEdanChecklists: state.edanChecklists.length,
      totalSupplyRequests: state.supplyRequests.length,
      generalObservations: _obsCtrl.text.trim(),
      teamHealthStatus: _teamHealth,
      isSynced: state.isOnline,
    );

    await state.addShiftReport(shift);

    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Row(
            children: [
              Icon(Icons.verified, color: Colors.green),
              SizedBox(width: 8),
              Text('Turno Cerrado Con Éxito', style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Informe [${shift.id}] generado.', style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Agente: ${shift.agentName}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                Text('Sector: ${shift.sector}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                Text('Incidencias Reportadas: ${shift.totalIncidentsReported}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                Text('Formularios EDAN: ${shift.totalEdanChecklists}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                Text('Pedidos Logísticos: ${shift.totalSupplyRequests}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 12),
                const Text('Reporte compilado y listo para exportar a Central.', style: TextStyle(color: Colors.greenAccent, fontSize: 11)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ENTENDIDO', style: TextStyle(color: Color(0xFFF59E0B))),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final user = state.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cierre de Turno y Reportes (RF15)'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Operational Metrics Summary Card
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CONSOLIDADO Y MÉTRICAS DEL TURNO (RF15)',
                      style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildMetricTile('INCIDENCIAS', '${state.incidents.length}', Icons.report),
                        _buildMetricTile('CHECKLIST EDAN', '${state.edanChecklists.length}', Icons.checklist),
                        _buildMetricTile('LOGÍSTICA', '${state.supplyRequests.length}', Icons.local_shipping),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sector Operativo: ${user?.assignedSector}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(
                      'Agente a Cargo: ${user?.fullName} (${user?.code})',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Form inputs for shift closure
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BALANCE FINAL Y EVALUACIÓN DEL OPERATIVO',
                      style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _teamHealth,
                      dropdownColor: const Color(0xFF1E293B),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Estado de Salud / Integridad de la Cuadrilla',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      items: [
                        'Óptimo (Sin Novedad)',
                        'Brigadistas con Agotamiento',
                        'Atención Médica Menor Requerida',
                        'Incidente de Seguridad Registrado'
                      ].map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
                      onChanged: (v) => setState(() => _teamHealth = v!),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _obsCtrl,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Observaciones Generales de Cierre de Turno',
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _closeShift,
              icon: const Icon(Icons.assignment_turned_in),
              label: const Text('GENERAR INFORME DE CIERRE DE TURNO'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'INFORMES DE TURNO ANTERIORES',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.shiftReports.length,
              itemBuilder: (context, index) {
                final rep = state.shiftReports[index];
                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.summarize, color: Color(0xFF4ADE80)),
                    title: Text(rep.id, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text(
                      'Incidencias: ${rep.totalIncidentsReported} | EDAN: ${rep.totalEdanChecklists} | Salud: ${rep.teamHealthStatus}',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blueGrey.shade700),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFF59E0B), size: 20),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

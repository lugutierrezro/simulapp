import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/incident_model.dart';
import '../widgets/status_badge.dart';
import 'incident_detail_screen.dart';

class IncidentListScreen extends StatefulWidget {
  const IncidentListScreen({super.key});

  @override
  State<IncidentListScreen> createState() => _IncidentListScreenState();
}

class _IncidentListScreenState extends State<IncidentListScreen> {
  String _selectedFilter = 'Todos';

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final incidents = state.incidents;

    List<IncidentModel> filtered = incidents;
    if (_selectedFilter != 'Todos') {
      filtered = incidents.where((i) => i.status.toLowerCase() == _selectedFilter.toLowerCase()).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Reportes (RF11)'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Filter Pills
          Container(
            height: 48,
            color: const Color(0xFF1E293B),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              children: ['Todos', 'En espera', 'Sincronizada', 'En atención', 'Atendida', 'Desestimada'].map((filter) {
                final isSel = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(filter, style: TextStyle(color: isSel ? Colors.black : Colors.white, fontSize: 11)),
                    selected: isSel,
                    selectedColor: const Color(0xFFF59E0B),
                    backgroundColor: const Color(0xFF0F172A),
                    onSelected: (val) {
                      if (val) setState(() => _selectedFilter = filter);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Incidents List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 48, color: Colors.blueGrey),
                        SizedBox(height: 12),
                        Text(
                          'No hay reportes de incidencias en este filtro',
                          style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Card(
                        color: const Color(0xFF1E293B),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => IncidentDetailScreen(incidentId: item.id),
                              ),
                            );
                          },
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: item.isSynced ? Colors.blue.withOpacity(0.2) : Colors.amber.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.isSynced ? Icons.cloud_done : Icons.cloud_off,
                              color: item.isSynced ? Colors.blue : Colors.amber,
                              size: 22,
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              SeverityBadge(severity: item.severity),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                '${item.category} • ${item.id}',
                                style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'GPS: ${item.latitude.toStringAsFixed(4)}, ${item.longitude.toStringAsFixed(4)} | ${item.timestamp.substring(11, 16)} hrs',
                                style: const TextStyle(color: Colors.white70, fontSize: 10),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  StatusBadge(status: item.status, isSynced: item.isSynced),
                                  const Spacer(),
                                  const Icon(Icons.chevron_right, color: Colors.white38, size: 18),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

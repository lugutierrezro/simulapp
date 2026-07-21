import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/incident_model.dart';
import '../widgets/watermark_photo_picker.dart';
import '../widgets/status_badge.dart';

class IncidentFormScreen extends StatefulWidget {
  const IncidentFormScreen({super.key});

  @override
  State<IncidentFormScreen> createState() => _IncidentFormScreenState();
}

class _IncidentFormScreenState extends State<IncidentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _category = 'Colapso';
  String _severity = 'Alta';
  String _requiredSupport = 'Ninguno';

  Map<String, String>? _photoEvidence;
  double _lat = -12.046374;
  double _lng = -77.042793;
  double _acc = 3.5;
  bool _isGpsRefreshing = false;

  final List<String> _categories = [
    'Colapso',
    'Fuga de Gas',
    'Incendio',
    'Deslizamiento',
    'Inundación',
    'Obstrucción de Vía',
    'Necesidad Médica',
    'Falla Eléctrica'
  ];

  final List<String> _supportOptions = [
    'Ninguno',
    'Unidad Hazmat Bomberos',
    'Ambulancia SAMU',
    'Maquinaria Pesada',
    'Rescate Canino / K9',
    'Refuerzo Policial'
  ];

  void _refreshGps() async {
    setState(() => _isGpsRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _lat = -12.046374 + ((DateTime.now().millisecond % 50) - 25) * 0.0001;
      _lng = -77.042793 + ((DateTime.now().second % 50) - 25) * 0.0001;
      _acc = 2.5 + (DateTime.now().second % 3);
      _isGpsRefreshing = false;
    });
  }

  void _submitIncident() async {
    if (!_formKey.currentState!.validate()) return;

    final state = Provider.of<AppState>(context, listen: false);
    final user = state.currentUser!;

    final incId = 'INC-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final incident = IncidentModel(
      id: incId,
      title: _titleCtrl.text.trim(),
      category: _category,
      severity: _severity,
      status: state.isOnline ? 'Sincronizada' : 'En espera',
      photoPath: _photoEvidence?['label'],
      watermarkInfo: _photoEvidence?['watermark'],
      latitude: _lat,
      longitude: _lng,
      accuracyMeters: _acc,
      sectorReference: user.assignedSector,
      agentId: user.code,
      agentName: user.fullName,
      timestamp: DateTime.now().toIso8601String(),
      tacticalNotes: _notesCtrl.text.trim(),
      requiredSupport: _requiredSupport,
      isSynced: state.isOnline,
    );

    await state.addIncident(incident);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.isOnline
                ? 'Incidencia [${incident.id}] enviada a Firebase/API Central.'
                : 'Incidencia [${incident.id}] guardada en Cola Local Offline (RF13).',
          ),
          backgroundColor: state.isOnline ? Colors.green : Colors.amber.shade900,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final user = state.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Incidencia (RF07-RF10)'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Category Card
              Card(
                color: const Color(0xFF1E293B),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DETALLES DE LA EMERGENCIA (RF07)',
                        style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _titleCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Título o Resumen de la Incidencia',
                          labelStyle: TextStyle(color: Colors.white70),
                          hintText: 'Ej. Colapso de techo en vivienda',
                          prefixIcon: Icon(Icons.report_problem, color: Color(0xFFF59E0B)),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingrese un título' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _category,
                        dropdownColor: const Color(0xFF1E293B),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Categoría Técnica',
                          labelStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.category, color: Color(0xFFF59E0B)),
                        ),
                        items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _category = v!),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Severity Classification Selector (RF08)
              Card(
                color: const Color(0xFF1E293B),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CLASIFICACIÓN DE SEVERIDAD (RF08)',
                        style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: ['Baja', 'Media', 'Alta', 'Crítica'].map((sev) {
                          final isSelected = _severity.toLowerCase().startsWith(sev.toLowerCase());
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: InkWell(
                                onTap: () => setState(() => _severity = sev == 'Crítica' ? 'Crítica (Prioridad 1)' : sev),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.amber.shade700 : Colors.white10,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected ? Colors.amber : Colors.white24,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      sev.toUpperCase(),
                                      style: TextStyle(
                                        color: isSelected ? Colors.black : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Center(child: SeverityBadge(severity: _severity)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Automatic GPS Capture (RF10)
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
                          const Text(
                            'GEORREFERENCIA AUTOMÁTICA GPS (RF10)',
                            style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          IconButton(
                            icon: _isGpsRefreshing
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.refresh, color: Colors.amber, size: 20),
                            onPressed: _refreshGps,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.my_location, color: Color(0xFF10B981), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'LAT: $_lat, LNG: $_lng',
                                  style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                Text(
                                  'Precisión: ±${_acc.toStringAsFixed(1)}m | Sector: ${user?.assignedSector}',
                                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Watermarked Photo Evidence (RF09, RNF08)
              WatermarkPhotoPicker(
                agentCode: user?.code ?? 'AGENTE-884',
                sector: user?.assignedSector ?? 'Sector 04',
                onPhotoSelected: (data) {
                  setState(() => _photoEvidence = data);
                },
              ),

              const SizedBox(height: 16),

              // Tactical Notes & Support Requested
              Card(
                color: const Color(0xFF1E293B),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NOTAS TÁCTICAS Y APOYO REQUERIDO',
                        style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _requiredSupport,
                        dropdownColor: const Color(0xFF1E293B),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Solicitud de Apoyo Adicional',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        items: _supportOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (v) => setState(() => _requiredSupport = v!),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _notesCtrl,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Notas Tácticas de Campo',
                          labelStyle: TextStyle(color: Colors.white70),
                          hintText: 'Detalle riesgos secundarios o instrucciones para la cuadrilla...',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitIncident,
                icon: const Icon(Icons.send),
                label: const Text('REGISTRAR E ENVIAR INCIDENCIA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

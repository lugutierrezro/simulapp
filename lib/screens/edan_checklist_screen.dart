import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/edan_model.dart';

class EdanChecklistScreen extends StatefulWidget {
  const EdanChecklistScreen({super.key});

  @override
  State<EdanChecklistScreen> createState() => _EdanChecklistScreenState();
}

class _EdanChecklistScreenState extends State<EdanChecklistScreen> {
  final _formKey = GlobalKey<FormState>();

  String _habitabilidad = 'Acceso Restringido';
  bool _colapsoParcial = false;
  bool _grietasGraves = false;
  bool _riesgoDerrumbe = false;

  bool _aguaPotable = true;
  bool _electricidad = false;
  bool _fugaGas = false;
  bool _telecom = true;

  bool _viaBloqueada = false;
  bool _accesoRescate = true;
  bool _puenteDanado = false;

  int _heridos = 0;
  int _damnificados = 0;
  bool _evacuacionUrgente = false;

  final _obsCtrl = TextEditingController();

  void _saveEdan() async {
    if (!_formKey.currentState!.validate()) return;

    final state = Provider.of<AppState>(context, listen: false);
    final user = state.currentUser!;

    final id = 'EDAN-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final edan = EdanChecklistModel(
      id: id,
      timestamp: DateTime.now().toIso8601String(),
      sector: user.assignedSector,
      agentId: user.code,
      agentName: user.fullName,
      habitabilidadStatus: _habitabilidad,
      tieneColapsoParcial: _colapsoParcial,
      tieneGrietasGraves: _grietasGraves,
      riesgoDerrumbeSecundario: _riesgoDerrumbe,
      tieneAguaPotable: _aguaPotable,
      tieneEnergiaElectrica: _electricidad,
      tieneFugaGas: _fugaGas,
      tieneTelecomunicaciones: _telecom,
      viaPrincipalBloqueada: _viaBloqueada,
      accesoVehiculoRescate: _accesoRescate,
      puenteOInfraestructuraDanada: _puenteDanado,
      estimacionHeridos: _heridos,
      estimacionDamnificados: _damnificados,
      requiereEvacuacionUrgente: _evacuacionUrgente,
      observacionesGenerales: _obsCtrl.text,
      isSynced: state.isOnline,
    );

    await state.addEdanChecklist(edan);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.isOnline
                ? 'Formulario EDAN registrado y sincronizado con el Servidor Central.'
                : 'Formulario EDAN guardado en Base de Datos Local (Offline Mode).',
          ),
          backgroundColor: state.isOnline ? Colors.green : Colors.amber.shade900,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist EDAN (RF06)'),
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
              // Header description
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFF59E0B)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.assignment_late, color: Color(0xFFF59E0B)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Evaluación Rápida de Daños y Necesidades (EDAN - 2026)\nComplete las verificaciones de campo por etapas.',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              _buildSectionTitle('1. ETAPA INFRAESTRUCTURA Y EDIFICACIONES', Icons.location_city),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _habitabilidad,
                        decoration: const InputDecoration(labelText: 'Estado de Habitabilidad'),
                        items: ['Habitable', 'Acceso Restringido', 'Inhabitable']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) => setState(() => _habitabilidad = v!),
                      ),
                      SwitchListTile(
                        title: const Text('Colapso Estructural Parcial/Total'),
                        value: _colapsoParcial,
                        onChanged: (v) => setState(() => _colapsoParcial = v),
                      ),
                      SwitchListTile(
                        title: const Text('Grietas Graves en Muros Muestrales'),
                        value: _grietasGraves,
                        onChanged: (v) => setState(() => _grietasGraves = v),
                      ),
                      SwitchListTile(
                        title: const Text('Riesgo de Derrumbe Secundario'),
                        value: _riesgoDerrumbe,
                        onChanged: (v) => setState(() => _riesgoDerrumbe = v),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              _buildSectionTitle('2. ETAPA SERVICIOS BÁSICOS', Icons.electrical_services),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Servicio de Agua Potable Activo'),
                        value: _aguaPotable,
                        onChanged: (v) => setState(() => _aguaPotable = v),
                      ),
                      SwitchListTile(
                        title: const Text('Energía Eléctrica Disponible'),
                        value: _electricidad,
                        onChanged: (v) => setState(() => _electricidad = v),
                      ),
                      SwitchListTile(
                        title: const Text('Fuga de Gas Detectada (Peligro)'),
                        subtitle: const Text('Activa alerta de evacución'),
                        value: _fugaGas,
                        onChanged: (v) => setState(() => _fugaGas = v),
                      ),
                      SwitchListTile(
                        title: const Text('Red de Telecomunicaciones Estable'),
                        value: _telecom,
                        onChanged: (v) => setState(() => _telecom = v),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              _buildSectionTitle('3. ETAPA ACCESIBILIDAD Y TRÁFICO', Icons.alt_route),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Vía Principal de Acceso Bloqueada'),
                        value: _viaBloqueada,
                        onChanged: (v) => setState(() => _viaBloqueada = v),
                      ),
                      SwitchListTile(
                        title: const Text('Acceso Habilitado para Vehículos de Rescate'),
                        value: _accesoRescate,
                        onChanged: (v) => setState(() => _accesoRescate = v),
                      ),
                      SwitchListTile(
                        title: const Text('Puentes o Vías Conectoras Dañadas'),
                        value: _puenteDanado,
                        onChanged: (v) => setState(() => _puenteDanado = v),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              _buildSectionTitle('4. POBLACIÓN AFECTADA Y OBSERVACIONES', Icons.people_alt),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Heridos Estimados'),
                              initialValue: '0',
                              onChanged: (v) => _heridos = int.tryParse(v) ?? 0,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Damnificados'),
                              initialValue: '0',
                              onChanged: (v) => _damnificados = int.tryParse(v) ?? 0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: const Text('¿Requiere Evacuación Urgente?'),
                        tileColor: _evacuacionUrgente ? Colors.red.shade50 : null,
                        value: _evacuacionUrgente,
                        onChanged: (v) => setState(() => _evacuacionUrgente = v),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _obsCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Observaciones Generales y Notas Tácticas',
                          hintText: 'Detalle puntos críticos encontrados...',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveEdan,
                icon: const Icon(Icons.check_circle),
                label: const Text('REGISTRAR EVALUACIÓN EDAN'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0F172A), size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

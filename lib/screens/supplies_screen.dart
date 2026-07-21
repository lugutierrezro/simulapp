import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/supply_model.dart';

class SuppliesScreen extends StatefulWidget {
  const SuppliesScreen({super.key});

  @override
  State<SuppliesScreen> createState() => _SuppliesScreenState();
}

class _SuppliesScreenState extends State<SuppliesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _itemCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '10');

  String _category = 'Kits de Rescate';
  String _unit = 'Unidades';
  String _priority = 'Urgente';

  final List<String> _categories = [
    'Kits de Rescate',
    'Agua Potable',
    'Herramientas Pesadas',
    'Primeros Auxilios / Médicos',
    'Raciones de Viveres',
    'Mantas y Carpas'
  ];

  void _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final state = Provider.of<AppState>(context, listen: false);
    final user = state.currentUser!;

    final id = 'SUP-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final req = SupplyRequestModel(
      id: id,
      itemCategory: _category,
      itemName: _itemCtrl.text.trim(),
      quantityRequested: int.tryParse(_qtyCtrl.text) ?? 1,
      unit: _unit,
      priorityLevel: _priority,
      sector: user.assignedSector,
      timestamp: DateTime.now().toIso8601String(),
      agentName: user.fullName,
      isSynced: state.isOnline,
    );

    await state.addSupplyRequest(req);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.isOnline
                ? 'Requerimiento de Suministro registrado y enviado al Mando.'
                : 'Requerimiento guardado en Cola Offline.',
          ),
          backgroundColor: state.isOnline ? Colors.green : Colors.amber.shade900,
        ),
      );
      _itemCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final supplies = state.supplyRequests;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Suministros (RF12)'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Card
            Card(
              color: const Color(0xFF1E293B),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SOLICITAR ASISTENCIA / LOGÍSTICA (RF12)',
                        style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _category,
                        dropdownColor: const Color(0xFF1E293B),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Categoría de Insumo',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _category = v!),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _itemCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Nombre / Especificación del Insumo',
                          labelStyle: TextStyle(color: Colors.white70),
                          hintText: 'Ej. Carpas térmicas para 4 personas',
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingrese el insumo' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _qtyCtrl,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Cantidad',
                                labelStyle: TextStyle(color: Colors.white70),
                              ),
                              validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _unit,
                              dropdownColor: const Color(0xFF1E293B),
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Unidad Medida',
                                labelStyle: TextStyle(color: Colors.white70),
                              ),
                              items: ['Unidades', 'Cajas', 'Litros', 'Kilos', 'Botiquines']
                                  .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                                  .toList(),
                              onChanged: (v) => setState(() => _unit = v!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _priority,
                        dropdownColor: const Color(0xFF1E293B),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Nivel de Prioridad Logística',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        items: ['Normal', 'Urgente', 'Crítico']
                            .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                            .toList(),
                        onChanged: (v) => setState(() => _priority = v!),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _submitRequest,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('ENVIAR PEDIDO DE ASISTENCIA'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF59E0B),
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 45),
                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'HISTORIAL DE REQUERIMIENTOS REGISTRADOS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: supplies.length,
              itemBuilder: (context, index) {
                final s = supplies[index];
                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.local_shipping, color: Color(0xFFF59E0B)),
                    title: Text(
                      '${s.itemName} (${s.quantityRequested} ${s.unit})',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    subtitle: Text(
                      'Categoría: ${s.itemCategory} | Prioridad: ${s.priorityLevel}',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: s.isSynced ? Colors.blue.withOpacity(0.2) : Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        s.isSynced ? 'Synced' : 'Offline',
                        style: TextStyle(color: s.isSynced ? Colors.blue : Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
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
}

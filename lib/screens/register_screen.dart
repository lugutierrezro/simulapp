import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _dniCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _entityCtrl;
  late TextEditingController _roleCtrl;
  late TextEditingController _teamCtrl;
  late TextEditingController _sectorCtrl;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AppState>(context, listen: false).currentUser;
    _nameCtrl = TextEditingController(text: user?.fullName ?? '');
    _dniCtrl = TextEditingController(text: user?.dni ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _entityCtrl = TextEditingController(text: user?.entity ?? 'Defensa Civil / INDECI');
    _roleCtrl = TextEditingController(text: user?.role ?? 'Brigadista Evaluador');
    _teamCtrl = TextEditingController(text: user?.teamGroup ?? 'Cuadrilla Alfa-1');
    _sectorCtrl = TextEditingController(text: user?.assignedSector ?? 'Sector 04 - Zona Crítica R-1');
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final state = Provider.of<AppState>(context, listen: false);
    final currentUser = state.currentUser!;

    final updated = UserModel(
      id: currentUser.id,
      code: currentUser.code,
      fullName: _nameCtrl.text,
      dni: _dniCtrl.text,
      phone: _phoneCtrl.text,
      entity: _entityCtrl.text,
      role: _roleCtrl.text,
      teamGroup: _teamCtrl.text,
      assignedSector: _sectorCtrl.text,
      token: currentUser.token,
      isLoggedIn: true,
    );

    state.updateUser(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil de Brigadista actualizado correctamente (RF02).'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Brigadista (RF02)'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: const Color(0xFF1E293B),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ficha Institucional de Identificación Operativa',
                        style: TextStyle(
                          color: Color(0xFFF59E0B),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Nombres y Apellidos Completos',
                          labelStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.person, color: Color(0xFFF59E0B)),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dniCtrl,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'DNI / Doc',
                                labelStyle: TextStyle(color: Colors.white70),
                                prefixIcon: Icon(Icons.badge, color: Color(0xFFF59E0B)),
                              ),
                              validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneCtrl,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Teléfono',
                                labelStyle: TextStyle(color: Colors.white70),
                                prefixIcon: Icon(Icons.phone, color: Color(0xFFF59E0B)),
                              ),
                              validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _entityCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Entidad de Adscripción',
                          labelStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.account_balance, color: Color(0xFFF59E0B)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _roleCtrl,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Rol Táctico',
                                labelStyle: TextStyle(color: Colors.white70),
                                prefixIcon: Icon(Icons.work, color: Color(0xFFF59E0B)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _teamCtrl,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                labelText: 'Cuadrilla / Grupo',
                                labelStyle: TextStyle(color: Colors.white70),
                                prefixIcon: Icon(Icons.groups, color: Color(0xFFF59E0B)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _sectorCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Sector Asignado',
                          labelStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.location_on, color: Color(0xFFF59E0B)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('GUARDAR DATOS OPERATIVOS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

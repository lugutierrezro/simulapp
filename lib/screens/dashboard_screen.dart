import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/network_bar.dart';
import 'sector_map_screen.dart';
import 'credential_screen.dart';
import 'edan_checklist_screen.dart';
import 'incident_form_screen.dart';
import 'incident_list_screen.dart';
import 'supplies_screen.dart';
import 'sync_queue_screen.dart';
import 'shift_closure_screen.dart';
import 'leader_dashboard_screen.dart';
import 'register_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final user = state.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.shield, color: Color(0xFFF59E0B), size: 24),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DEFENSA CIVIL 2026',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5),
                ),
                Text(
                  'Agente: ${user?.fullName ?? "Cargando..."}',
                  style: const TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_2, color: Color(0xFFF59E0B)),
            tooltip: 'Credencial Digital QR (RF03)',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CredentialScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Colors.blue),
            tooltip: 'Dashboard Líder',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderDashboardScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Cerrar Sesión',
            onPressed: () => state.logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Global Network Status Bar
          NetworkBar(
            state: state,
            onOpenSyncQueue: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SyncQueueScreen()));
            },
          ),

          // Main Body Tabs
          Expanded(
            child: _buildBodyTab(_currentIndex),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFF59E0B),
        unselectedItemColor: Colors.blueGrey,
        backgroundColor: const Color(0xFF0F172A),
        type: BottomNavigationBarType.fixed,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Sector/Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.report_problem), label: 'Incidencias'),
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Motor Sync'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in), label: 'Cierre'),
        ],
      ),
    );
  }

  Widget _buildBodyTab(int index) {
    switch (index) {
      case 1:
        return const SectorMapScreen();
      case 2:
        return const IncidentListScreen();
      case 3:
        return const SyncQueueScreen();
      case 4:
        return const ShiftClosureScreen();
      case 0:
      default:
        return _buildHomeOverview();
    }
  }

  Widget _buildHomeOverview() {
    final state = Provider.of<AppState>(context);
    final user = state.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Assigned Sector Banner (RF04)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF59E0B), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'SECTOR ASIGNADO (RF04)',
                      style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade900,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'RIESGO CRÍTICO',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  user?.assignedSector ?? 'Sector 04 - Zona Crítica R-1',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cuadrilla: ${user?.teamGroup} | Rol: ${user?.role}',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'MÓDULOS OPERATIVOS DE CAMPO (MVP)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12),

          // Grid of Action Modules
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildModuleCard(
                'Registrar Incidencia',
                'Severidad, Foto + GPS (RF07-10)',
                Icons.add_alert,
                const Color(0xFFDC2626),
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IncidentFormScreen())),
              ),
              _buildModuleCard(
                'Checklist EDAN',
                'Evaluación de Daños (RF06)',
                Icons.checklist_rtl,
                const Color(0xFFF59E0B),
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EdanChecklistScreen())),
              ),
              _buildModuleCard(
                'Mapa & Despliegue',
                'Control de Tiempo (RF04/RF05)',
                Icons.map,
                const Color(0xFF0284C7),
                () => setState(() => _currentIndex = 1),
              ),
              _buildModuleCard(
                'Pedir Suministros',
                'Kits, Agua, Insumos (RF12)',
                Icons.local_shipping,
                const Color(0xFF10B981),
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SuppliesScreen())),
              ),
              _buildModuleCard(
                'Credencial QR',
                'Ficha de Identificación (RF03)',
                Icons.qr_code,
                const Color(0xFF8B5CF6),
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CredentialScreen())),
              ),
              _buildModuleCard(
                'Perfil Brigadista',
                'Editar Datos (RF02)',
                Icons.person_pin,
                const Color(0xFF64748B),
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Recent Incidents List Preview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'INCIDENCIAS RECIENTES EN SECTOR',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
              ),
              TextButton(
                onPressed: () => setState(() => _currentIndex = 2),
                child: const Text('Ver Historial', style: TextStyle(color: Color(0xFF0284C7), fontSize: 12)),
              ),
            ],
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.incidents.length > 3 ? 3 : state.incidents.length,
            itemBuilder: (context, index) {
              final inc = state.incidents[index];
              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(inc.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  subtitle: Text('Estado: ${inc.status} | GPS: ${inc.latitude.toStringAsFixed(3)}, ${inc.longitude.toStringAsFixed(3)}', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                  trailing: Icon(inc.isSynced ? Icons.cloud_done : Icons.cloud_off, color: inc.isSynced ? Colors.blue : Colors.amber, size: 18),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white60, fontSize: 9),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

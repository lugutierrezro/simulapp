import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/tactical_map_painter.dart';

class SectorMapScreen extends StatefulWidget {
  const SectorMapScreen({super.key});

  @override
  State<SectorMapScreen> createState() => _SectorMapScreenState();
}

class _SectorMapScreenState extends State<SectorMapScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _timerTicker;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _timerTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      final state = Provider.of<AppState>(context, listen: false);
      if (state.isDeployed && state.deploymentStartTime != null) {
        setState(() {
          _elapsed = DateTime.now().difference(state.deploymentStartTime!);
        });
      } else {
        if (_elapsed != Duration.zero) {
          setState(() => _elapsed = Duration.zero);
        }
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timerTicker?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final hh = d.inHours.toString().padLeft(2, '0');
    final mm = (d.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final user = state.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sector & Mapa Táctico (RF04/RF05)'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Deployment Control Card (RF05)
          Container(
            padding: const EdgeInsets.all(14),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            state.isDeployed ? Icons.timer : Icons.location_off,
                            color: state.isDeployed ? const Color(0xFF4ADE80) : Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            state.isDeployed ? 'DESPLIEGUE ACTIVO' : 'NO DESPLEGADO EN CAMPO',
                            style: TextStyle(
                              color: state.isDeployed ? const Color(0xFF4ADE80) : Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        state.isDeployed
                            ? 'Tiempo transcurrido: ${_formatDuration(_elapsed)}'
                            : 'Presione para registrar hora exacta de llegada al sector',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (state.isDeployed) {
                      state.endDeployment();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Despliegue finalizado.')),
                      );
                    } else {
                      state.startDeployment();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Despliegue iniciado correctamente (RF05).'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  icon: Icon(state.isDeployed ? Icons.stop : Icons.play_arrow),
                  label: Text(state.isDeployed ? 'FINALIZAR' : 'REGISTRAR INICIO'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.isDeployed ? Colors.red.shade700 : const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Tactical Map View
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size.infinite,
                      painter: TacticalMapPainter(
                        incidents: state.incidents,
                        pulseValue: _pulseController.value,
                        selectedSector: user?.assignedSector ?? 'Sector 04',
                      ),
                    );
                  },
                ),
                // Overlay Map Controls & Legend
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xEE0F172A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blueGrey.shade700),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.assignedSector ?? 'Sector 04 - Zona Crítica',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        const Text(
                          'NIVEL DE RIESGO: PRELIMINAR ALTO',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sector Tactical Details List
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFF0F172A),
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  const Text(
                    'PUNTOS DE CONTROL Y REFERENCIAS DEL SECTOR (RF04)',
                    style: TextStyle(
                      color: Color(0xFFF59E0B),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildControlPoint(
                    'Punto de Reunión Principal:',
                    'Parque Central de Chorrillos (Zona Segura A-1)',
                    Icons.shield,
                    Colors.blue,
                  ),
                  _buildControlPoint(
                    'Puesto de Mando Avanzado:',
                    'Colegio Pedro Ruiz Gallo (Servicios Básicos & Salud)',
                    Icons.local_hospital,
                    Colors.green,
                  ),
                  _buildControlPoint(
                    'Vías de Evacuación:',
                    'Av. Huaylas (Hacia Panamericana Sur)',
                    Icons.alt_route,
                    Colors.amber,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildControlPoint(String title, String desc, IconData icon, Color color) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  Text(
                    desc,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

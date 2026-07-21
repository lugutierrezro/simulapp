import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../services/firebase_service.dart';

class SyncQueueScreen extends StatefulWidget {
  const SyncQueueScreen({super.key});

  @override
  State<SyncQueueScreen> createState() => _SyncQueueScreenState();
}

class _SyncQueueScreenState extends State<SyncQueueScreen> {
  final _tokenCtrl = TextEditingController();
  bool _isTestingDb = false;

  @override
  void initState() {
    super.initState();
    final state = Provider.of<AppState>(context, listen: false);
    _tokenCtrl.text = state.firebaseAuthToken;
  }

  void _testFirebase() async {
    setState(() => _isTestingDb = true);
    final state = Provider.of<AppState>(context, listen: false);
    final res = await FirebaseService.testConnection(authToken: state.firebaseAuthToken);
    setState(() => _isTestingDb = false);

    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: Row(
            children: [
              Icon(
                res['success'] == true ? Icons.cloud_done : Icons.cloud_off,
                color: res['success'] == true ? Colors.green : Colors.amber,
              ),
              const SizedBox(width: 8),
              const Text('Test Firebase Realtime DB', style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'URL: ${state.firebaseDbUrl}',
                  style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Status Code: ${res['statusCode'] ?? "N/A"}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Text(
                  'Respuesta del Servidor:\n${res['body'] ?? res['error'] ?? "Sin datos"}',
                  style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 10),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: Color(0xFFF59E0B))),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final pendingCount = state.pendingSyncCount;
    final isOnline = state.isOnline;
    final isSyncing = state.isSyncing;
    final logs = state.syncLogs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Motor Sync & Firebase RTDB'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Firebase Realtime DB Banner Card
          Container(
            padding: const EdgeInsets.all(14),
            color: const Color(0xFF1E293B),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Color(0xFFF59E0B), size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'FIREBASE REALTIME DATABASE',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Text(
                            state.firebaseDbUrl,
                            style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 10, fontFamily: 'monospace'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isTestingDb ? null : _testFirebase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      child: _isTestingDb
                          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('PROBAR RED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Auth Token input field
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: TextField(
                          controller: _tokenCtrl,
                          style: const TextStyle(color: Colors.white, fontSize: 11),
                          decoration: const InputDecoration(
                            hintText: 'Firebase Auth Token (Opcional si es público)',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          onChanged: (val) => state.setFirebaseAuthToken(val),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(color: Colors.white12),

                // Network & Sync Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOnline ? 'ESTADO: ONLINE (CONECTADO)' : 'ESTADO: OFFLINE (SIN RED)',
                          style: TextStyle(
                            color: isOnline ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Paquetes en cola SQLite/Hive: $pendingCount',
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: (isOnline && pendingCount > 0 && !isSyncing)
                          ? () {
                              state.autoSyncPendingQueue();
                            }
                          : null,
                      icon: isSyncing
                          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.sync, size: 16),
                      label: Text(isSyncing ? 'ENVIANDO...' : 'SINCRONIZAR AHORA'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Text('Simular Conexión de Red:', style: TextStyle(color: Colors.white, fontSize: 11)),
                    const Spacer(),
                    Switch(
                      value: isOnline,
                      activeColor: const Color(0xFF4ADE80),
                      inactiveThumbColor: const Color(0xFFF87171),
                      onChanged: (val) {
                        state.setNetworkOnline(val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.terminal, color: Color(0xFF0F172A), size: 18),
                SizedBox(width: 8),
                Text(
                  'CONSOLA LOGS TRANSMISIÓN FIREBASE RTDB',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Log Output Terminal
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF020617),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blueGrey.shade800),
              ),
              child: logs.isEmpty
                  ? const Center(
                      child: Text(
                        'Esperando eventos de sincronización con Firebase...',
                        style: TextStyle(color: Colors.blueGrey, fontFamily: 'monospace', fontSize: 11),
                      ),
                    )
                  : ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            log,
                            style: TextStyle(
                              color: log.contains('RESTABLECIDA') || log.contains('enviada') || log.contains('sincronizado') || log.contains('200 OK')
                                  ? const Color(0xFF4ADE80)
                                  : log.contains('OFFLINE') || log.contains('guardada')
                                      ? const Color(0xFFFBBF24)
                                      : Colors.white70,
                              fontFamily: 'monospace',
                              fontSize: 10.5,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

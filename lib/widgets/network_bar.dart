import 'package:flutter/material.dart';
import '../state/app_state.dart';

class NetworkBar extends StatelessWidget {
  final AppState state;
  final VoidCallback onOpenSyncQueue;

  const NetworkBar({
    super.key,
    required this.state,
    required this.onOpenSyncQueue,
  });

  @override
  Widget build(BuildContext context) {
    final isOnline = state.isOnline;
    final pending = state.pendingSyncCount;
    final isSyncing = state.isSyncing;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: isOnline ? const Color(0xFF1E293B) : const Color(0xFF450A0A),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          // Connection Status indicator
          Icon(
            isOnline ? Icons.wifi : Icons.wifi_off,
            color: isOnline ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isOnline ? 'RED OPERATIVA (ONLINE)' : 'MODO OFFLINE (SIN RED)',
                  style: TextStyle(
                    color: isOnline ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  isOnline
                      ? 'Sincronización automática con servidor central activada'
                      : 'Almacenando en SQLite/Hive local. Se enviará al detectar red',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Offline Queue Button
          InkWell(
            onTap: onOpenSyncQueue,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: pending > 0 ? Colors.amber.shade800 : Colors.white12,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  isSyncing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.cloud_upload_outlined, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Cola: $pending',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Simulated Switch
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: isOnline,
              activeColor: const Color(0xFF4ADE80),
              inactiveThumbColor: const Color(0xFFF87171),
              inactiveTrackColor: Colors.red.shade900,
              onChanged: (val) {
                state.setNetworkOnline(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}

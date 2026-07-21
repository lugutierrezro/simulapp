import 'package:flutter/material.dart';

class SeverityBadge extends StatelessWidget {
  final String severity;

  const SeverityBadge({super.key, required this.severity});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg = Colors.white;
    IconData icon;

    switch (severity.toLowerCase()) {
      case 'crítica':
      case 'crítica (prioridad 1)':
      case 'prioridad 1':
        bg = const Color(0xFFD32F2F); // Red
        icon = Icons.warning_amber_rounded;
        break;
      case 'alta':
        bg = const Color(0xFFE65100); // Orange
        icon = Icons.error_outline;
        break;
      case 'media':
        bg = const Color(0xFFF57F17); // Yellow/Amber
        icon = Icons.info_outline;
        break;
      case 'baja':
      default:
        bg = const Color(0xFF388E3C); // Green
        icon = Icons.check_circle_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: bg.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            severity.toUpperCase(),
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isSynced;

  const StatusBadge({super.key, required this.status, this.isSynced = false});

  @override
  Widget build(BuildContext context) {
    Color bg;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'sincronizada':
        bg = const Color(0xFF1976D2);
        icon = Icons.cloud_done;
        break;
      case 'en espera':
      case 'registrada':
        bg = const Color(0xFF757575);
        icon = Icons.cloud_off;
        break;
      case 'en atención':
        bg = const Color(0xFF8E24AA);
        icon = Icons.engineering;
        break;
      case 'atendida':
        bg = const Color(0xFF2E7D32);
        icon = Icons.task_alt;
        break;
      case 'desestimada':
        bg = const Color(0xFFC62828);
        icon = Icons.cancel;
        break;
      default:
        bg = Colors.blueGrey;
        icon = Icons.label;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.15),
        border: Border.all(color: bg, width: 1.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: bg),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: bg,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

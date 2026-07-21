import 'dart:math';
import 'package:flutter/material.dart';
import '../models/incident_model.dart';

class TacticalMapPainter extends CustomPainter {
  final List<IncidentModel> incidents;
  final double pulseValue;
  final String selectedSector;

  TacticalMapPainter({
    required this.incidents,
    required this.pulseValue,
    required this.selectedSector,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF0F172A); // Dark Tactical background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw Grid Lines
    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 1.0;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // High risk zone polygon
    final hazardPaint = Paint()
      ..color = const Color(0x33DC2626) // Semi transparent Red
      ..style = PaintingStyle.fill;

    final hazardPath = Path()
      ..moveTo(size.width * 0.1, size.height * 0.2)
      ..lineTo(size.width * 0.6, size.height * 0.15)
      ..lineTo(size.width * 0.8, size.height * 0.5)
      ..lineTo(size.width * 0.35, size.height * 0.7)
      ..close();
    canvas.drawPath(hazardPath, hazardPaint);

    final hazardBorder = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(hazardPath, hazardBorder);

    // Label Risk Zone
    const textSpan = TextSpan(
      text: 'ZONA DE ALTO RIESGO R-1',
      style: TextStyle(
        color: Color(0xFFEF4444),
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.15, size.height * 0.22));

    // Draw Command Base / Shelter
    _drawIconPin(
      canvas,
      Offset(size.width * 0.85, size.height * 0.8),
      Icons.local_hospital,
      const Color(0xFF3B82F6),
      'PUESTO DE MANDO Y SALUD',
    );

    // Draw Incidents Pins
    for (int i = 0; i < incidents.length; i++) {
      final inc = incidents[i];
      // Deterministic pin position based on hash code or coordinates
      final posX = (size.width * 0.2) + ((inc.id.hashCode.abs() % 60) / 100.0) * size.width * 0.6;
      final posY = (size.height * 0.25) + ((inc.title.hashCode.abs() % 50) / 100.0) * size.height * 0.5;

      Color color;
      switch (inc.severity.toLowerCase()) {
        case 'crítica':
        case 'crítica (prioridad 1)':
        case 'prioridad 1':
          color = const Color(0xFFEF4444);
          break;
        case 'alta':
          color = const Color(0xFFF97316);
          break;
        case 'media':
          color = const Color(0xFFEAB308);
          break;
        case 'baja':
        default:
          color = const Color(0xFF22C55E);
          break;
      }

      _drawIncidentPin(canvas, Offset(posX, posY), inc.title, color);
    }

    // Draw Current Agent Position (Pulsing Radar)
    final agentPos = Offset(size.width * 0.45, size.height * 0.55);

    // Radar pulse ring
    final pulseRadius = 15.0 + (pulseValue * 25.0);
    final pulsePaint = Paint()
      ..color = const Color(0xFF10B981).withOpacity(max(0.0, 0.6 - (pulseValue * 0.6)))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(agentPos, pulseRadius, pulsePaint);

    // Agent Center Dot
    final agentPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(agentPos, 8.0, agentPaint);

    final agentBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(agentPos, 8.0, agentBorder);

    // Label Agent
    const agentSpan = TextSpan(
      text: ' SU POSICIÓN (GPS ±3.5m) ',
      style: TextStyle(
        color: Color(0xFF10B981),
        fontSize: 10,
        fontWeight: FontWeight.bold,
        backgroundColor: Color(0xDD000000),
      ),
    );
    final agentPainter = TextPainter(text: agentSpan, textDirection: TextDirection.ltr);
    agentPainter.layout();
    agentPainter.paint(canvas, Offset(agentPos.dx - 50, agentPos.dy + 12));
  }

  void _drawIncidentPin(Canvas canvas, Offset pos, String label, Color color) {
    final pinPaint = Paint()..color = color;
    final shadowPaint = Paint()..color = Colors.black45;

    canvas.drawCircle(pos.translate(0, 3), 10, shadowPaint);
    canvas.drawCircle(pos, 9, pinPaint);

    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(pos, 3, innerPaint);

    // Label snippet
    final shortLabel = label.length > 18 ? '${label.substring(0, 15)}...' : label;
    final span = TextSpan(
      text: shortLabel,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 9,
        fontWeight: FontWeight.w600,
        backgroundColor: Color(0xCC0F172A),
      ),
    );
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(pos.dx - (tp.width / 2), pos.dy - 22));
  }

  void _drawIconPin(Canvas canvas, Offset pos, IconData icon, Color color, String label) {
    final bgPaint = Paint()..color = color;
    canvas.drawCircle(pos, 10, bgPaint);

    final span = TextSpan(
      text: label,
      style: TextStyle(
        color: color,
        fontSize: 9,
        fontWeight: FontWeight.bold,
        backgroundColor: const Color(0xCC000000),
      ),
    );
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, Offset(pos.dx - (tp.width / 2), pos.dy + 12));
  }

  @override
  bool shouldRepaint(covariant TacticalMapPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue || oldDelegate.incidents.length != incidents.length;
  }
}

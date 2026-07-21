import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/incident_model.dart';
import '../models/edan_model.dart';
import '../models/supply_model.dart';
import '../models/shift_model.dart';

class FirebaseService {
  static const String databaseUrl = 'https://simulapp-14400-default-rtdb.firebaseio.com';

  static Uri _buildUri(String path, {String? authToken}) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final urlStr = authToken != null && authToken.isNotEmpty
        ? '$databaseUrl$cleanPath.json?auth=$authToken'
        : '$databaseUrl$cleanPath.json';
    return Uri.parse(urlStr);
  }

  /// Tests connection to Firebase Realtime Database
  static Future<Map<String, dynamic>> testConnection({String? authToken}) async {
    final uri = _buildUri('health_check', authToken: authToken);
    try {
      final res = await http.get(uri);
      return {
        'success': res.statusCode >= 200 && res.statusCode < 300,
        'statusCode': res.statusCode,
        'body': res.body,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Fetches user details from Firebase Realtime Database
  static Future<Map<String, dynamic>?> fetchUser(String agentCode, {String? authToken}) async {
    final cleanCode = agentCode.trim().toUpperCase();
    final uri = _buildUri('users/$cleanCode', authToken: authToken);
    try {
      final res = await http.get(uri);
      if (res.statusCode >= 200 && res.statusCode < 300 && res.body != 'null') {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  /// Registers or updates a user profile in Firebase Realtime Database
  static Future<bool> registerOrUpdateUser(UserModel user, {String? password, String? authToken}) async {
    final cleanCode = user.code.trim().toUpperCase();
    final uri = _buildUri('users/$cleanCode', authToken: authToken);
    try {
      final userJson = user.toJson();
      if (password != null && password.isNotEmpty) {
        userJson['password'] = password;
      }
      final res = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userJson),
      );
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  /// Pushes an incident to Firebase Realtime Database
  static Future<bool> pushIncident(IncidentModel incident, {String? authToken}) async {
    final uri = _buildUri('incidents/${incident.id}', authToken: authToken);
    try {
      final res = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(incident.toJson()),
      );
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  /// Pushes an EDAN checklist form to Firebase Realtime Database
  static Future<bool> pushEdanChecklist(EdanChecklistModel edan, {String? authToken}) async {
    final uri = _buildUri('edan/${edan.id}', authToken: authToken);
    try {
      final res = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(edan.toJson()),
      );
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  /// Pushes a supply request to Firebase Realtime Database
  static Future<bool> pushSupplyRequest(SupplyRequestModel supply, {String? authToken}) async {
    final uri = _buildUri('supplies/${supply.id}', authToken: authToken);
    try {
      final res = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(supply.toJson()),
      );
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  /// Pushes a shift report to Firebase Realtime Database
  static Future<bool> pushShiftReport(ShiftReportModel shift, {String? authToken}) async {
    final uri = _buildUri('shifts/${shift.id}', authToken: authToken);
    try {
      final res = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(shift.toJson()),
      );
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false;
    }
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/incident_model.dart';
import '../models/edan_model.dart';
import '../models/supply_model.dart';
import '../models/shift_model.dart';

class StorageService {
  static const String _keyUser = 'app_user';
  static const String _keyIncidents = 'app_incidents';
  static const String _keyEdan = 'app_edan';
  static const String _keySupplies = 'app_supplies';
  static const String _keyShifts = 'app_shifts';
  static const String _keyDeploymentStart = 'app_deployment_start';
  static const String _keyNetworkOnline = 'app_network_online';

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUser);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveIncidents(List<IncidentModel> incidents) async {
    final prefs = await SharedPreferences.getInstance();
    final listJson = incidents.map((e) => e.toJson()).toList();
    await prefs.setString(_keyIncidents, jsonEncode(listJson));
  }

  static Future<List<IncidentModel>> getIncidents() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyIncidents);
    if (raw == null) return [];
    try {
      final List decoded = jsonDecode(raw);
      return decoded.map((e) => IncidentModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveEdanChecklists(List<EdanChecklistModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final listJson = list.map((e) => e.toJson()).toList();
    await prefs.setString(_keyEdan, jsonEncode(listJson));
  }

  static Future<List<EdanChecklistModel>> getEdanChecklists() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyEdan);
    if (raw == null) return [];
    try {
      final List decoded = jsonDecode(raw);
      return decoded.map((e) => EdanChecklistModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveSupplyRequests(List<SupplyRequestModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final listJson = list.map((e) => e.toJson()).toList();
    await prefs.setString(_keySupplies, jsonEncode(listJson));
  }

  static Future<List<SupplyRequestModel>> getSupplyRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keySupplies);
    if (raw == null) return [];
    try {
      final List decoded = jsonDecode(raw);
      return decoded.map((e) => SupplyRequestModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveShiftReports(List<ShiftReportModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final listJson = list.map((e) => e.toJson()).toList();
    await prefs.setString(_keyShifts, jsonEncode(listJson));
  }

  static Future<List<ShiftReportModel>> getShiftReports() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyShifts);
    if (raw == null) return [];
    try {
      final List decoded = jsonDecode(raw);
      return decoded.map((e) => ShiftReportModel.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveDeploymentStartTime(DateTime? dt) async {
    final prefs = await SharedPreferences.getInstance();
    if (dt == null) {
      await prefs.remove(_keyDeploymentStart);
    } else {
      await prefs.setString(_keyDeploymentStart, dt.toIso8601String());
    }
  }

  static Future<DateTime?> getDeploymentStartTime() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyDeploymentStart);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  static Future<void> saveNetworkOnline(bool isOnline) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNetworkOnline, isOnline);
  }

  static Future<bool> getNetworkOnline() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNetworkOnline) ?? true;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/audit_log.dart';
import '../models/barang.dart';
import '../models/purchase_request.dart';

class ApiService {
  // Ganti base URL ini sesuai dengan URL Laravel Anda.
  // Untuk Chrome/web: http://127.0.0.1:8000
  // Untuk Android emulator: http://10.0.2.2:8000
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Fetch semua barang (inventory) dari /api/barangs
  static Future<List<Barang>> getBarangs() async {
    final response = await http.get(Uri.parse('$baseUrl/barangs'));
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      // Laravel Resource biasanya mengembalikan { "data": [...] }
      final List<dynamic> data = jsonBody is List ? jsonBody : jsonBody['data'] ?? [];
      return data.map((e) => Barang.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Gagal memuat data barang (status: ${response.statusCode})');
    }
  }

  /// Fetch semua approvals (purchase requests) dari /api/approvals
  static Future<List<PurchaseRequest>> getApprovals() async {
    final response = await http.get(Uri.parse('$baseUrl/approvals'));
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> data = jsonBody is List ? jsonBody : jsonBody['data'] ?? [];
      return data.map((e) => PurchaseRequest.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Gagal memuat data approvals (status: ${response.statusCode})');
    }
  }

  /// Fetch audit logs dari /api/audit-logs
  static Future<List<AuditLog>> getAuditLogs() async {
    final response = await http.get(Uri.parse('$baseUrl/audit-logs'));
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> data = jsonBody is List ? jsonBody : jsonBody['data'] ?? [];
      return data.map((e) => AuditLog.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Gagal memuat audit log (status: ${response.statusCode})');
    }
  }

  /// Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sanctum/token'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
        'password': password,
        'device_name': 'flutter_app',
      },
    );
    
    return {
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    };
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/intervention.dart';
import 'auth_service.dart';

/// Accès à l'API FieldOps.
class ApiClient {
  ApiClient(this._auth);

  static const baseUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:3000/api');

  final AuthService _auth;

  Future<Map<String, String>> _headers() async {
    final token = await _auth.token();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<Intervention>> todayInterventions() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final response = await http.get(Uri.parse('$baseUrl/interventions?date=$today'), headers: await _headers());
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((json) => Intervention.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> updateStatus(int id, String status, {String? report}) async {
    await http.patch(
      Uri.parse('$baseUrl/interventions/$id/status'),
      headers: await _headers(),
      body: jsonEncode({'status': status, 'report': report}),
    );
  }
}

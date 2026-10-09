import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

/// Connexion du technicien et conservation du jeton d'accès.
class AuthService {
  static const _tokenKey = 'auth_token';

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiClient.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode != 200) {
      return false;
    }
    final token = jsonDecode(response.body)['token'] as String;
    final prefs = await SharedPreferences.getInstance();
    // TODO: stocker le jeton dans un stockage chiffré
    await prefs.setString(_tokenKey, token);
    return true;
  }

  Future<String?> token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}

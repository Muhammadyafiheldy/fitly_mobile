import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitly_v1/models/user.dart';
import 'package:fitly_v1/models/article.dart';

class ApiService {
  static const String baseUrl = 'https://55a6-110-137-110-182.ngrok-free.app/api';
  static String? _token;

  // Simpan token
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Ambil token
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Hapus token
  static Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _token = null;
  }

  // Header dengan token
  static Future<Map<String, String>> getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Register user
  static Future<User> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      await _saveToken(_token!);
      return User.fromJson(data['user']);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to register');
    }
  }

  // Login user
  static Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['token'] == null || data['user'] == null) {
        throw Exception('Token or user not found in response');
      }
      _token = data['token'];
      await _saveToken(_token!);
      return User.fromJson(data['user']);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to login');
    }
  }

  // Ambil artikel
  // static Future<List<Article>> getArticles() async {
  //   final token = await _getToken();
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/articles'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Accept': 'application/json',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final jsonData = jsonDecode(response.body);
  //     // jika response bentuknya list langsung
  //     if (jsonData is List) {
  //       return jsonData.map((json) => Article.fromJson(json)).toList();
  //     }
  //     // jika response bentuknya {success, data: [...]}
  //     if (jsonData is Map && jsonData['data'] is List) {
  //       return (jsonData['data'] as List).map((json) => Article.fromJson(json)).toList();
  //     }
  //     throw Exception('Format artikel tidak dikenali');
  //   } else {
  //     throw Exception('Gagal memuat artikel');
  //   }
  // }

  // Logout
  static Future<void> logout() async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      await _clearToken();
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to logout');
    }
  }

  // Update user
  static Future<Map<String, dynamic>> updateUser({
    String? name,
    String? email,
    String? password,
  }) async {
    final headers = await getHeaders();
    final body = <String, String>{};
    if (name != null) body['name'] = name;
    if (email != null) body['email'] = email;
    if (password != null) body['password'] = password;

    final response = await http.put(
      Uri.parse('$baseUrl/user/update'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to update user');
    }
  }
}

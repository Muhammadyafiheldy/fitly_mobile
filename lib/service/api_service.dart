import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitly_v1/models/user.dart';
import 'package:fitly_v1/models/article.dart';
import 'package:http_parser/http_parser.dart';
import 'package:fitly_v1/models/user.dart';
import 'package:fitly_v1/models/bmi.dart';
import 'package:fitly_v1/models/recommendation.dart'; // Import model Recommendation

class ApiService {
  static const String baseUrl =
      'https://6161-110-137-78-148.ngrok-free.app/api';
  static const String baseImageUrl =
      'https://6161-110-137-78-148.ngrok-free.app/storage/'; // URL dasar untuk gambar
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
  static Future<User> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (responseBody['token'] == null || responseBody['user'] == null) {
        throw Exception('Respon tidak lengkap dari server');
      }

      _token = responseBody['token'];
      await _saveToken(_token!);

      return User.fromJson(responseBody['user']);
    } else {
      String errorMsg = responseBody['message'] ?? 'Gagal mendaftar';
      if (responseBody['errors'] != null) {
        errorMsg = (responseBody['errors'] as Map).values.first[0];
      }
      throw Exception(errorMsg);
    }
  }

  // Login user
  static Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (responseBody['token'] == null || responseBody['user'] == null) {
        throw Exception('Token atau data user tidak ditemukan');
      }

      _token = responseBody['token'];
      await _saveToken(_token!);

      return User.fromJson(responseBody['user']);
    } else {
      String errorMsg = responseBody['message'] ?? 'Gagal login';
      if (responseBody['errors'] != null) {
        errorMsg = (responseBody['errors'] as Map).values.first[0];
      }
      throw Exception(errorMsg);
    }
  }

  // Ambil artikel
  static Future<List<Article>> getArticles() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/articles'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> articleListJson;

      if (jsonData is List) {
        articleListJson = jsonData;
      } else if (jsonData is Map && jsonData['data'] is List) {
        articleListJson = jsonData['data'] as List;
      } else {
        throw Exception('Format artikel tidak dikenali');
      }

      return articleListJson.map((json) {
        String imageUrl =
            json['image'] != null
                ? baseImageUrl + json['image']
                : 'https://placehold.co/200x100/CCCCCC/000000?text=No+Image';

        return Article(
          id: json['id'],
          title: json['title'],
          content: json['content'],
          image: imageUrl,
        );
      }).toList();
    } else {
      throw Exception(
        'Gagal memuat artikel: ${response.statusCode} ${response.body}',
      );
    }
  }

  // Ambil Rekomendasi (metode GET)
  static Future<List<Recommendation>> getRecommendations() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse(
        '$baseUrl/recommendations',
      ), // Endpoint untuk mengambil semua rekomendasi
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> recommendationListJson;

      // Bagian ini adalah sumber masalahnya:
      if (jsonData is Map && jsonData['data'] is List) {
        // Backend mengembalikan { "success": true, "data": [...] }
        recommendationListJson = jsonData['data'] as List;
      } else {
        throw Exception('Format rekomendasi tidak dikenali');
      }

      return recommendationListJson
          .map((json) => Recommendation.fromJson(json))
          .toList();
    } else {
      throw Exception(
        'Gagal memuat rekomendasi: ${response.statusCode} ${response.body}',
      );
    }
  }

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

  static Future<Map<String, dynamic>> updateProfile({
    required String token,
    String? name,
    String? email,
    String?
    currentPassword, // Jika Anda ingin menambahkan validasi password lama di Laravel
    String? newPassword,
    String? newPasswordConfirmation,
    File? foto,
  }) async {
    var request = http.MultipartRequest(
      'POST', // <-- PERUBAHAN UTAMA DI SINI: GANTI DARI 'PUT' MENJADI 'POST'
      Uri.parse('$baseUrl/user/update'), // Endpoint Laravel Anda tetap PUT
    );
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // PENTING: Tambahkan ini untuk memberitahu Laravel bahwa ini sebenarnya adalah permintaan PUT
    // Ini adalah "method spoofing" karena MultipartRequest dengan file tidak bisa langsung PUT
    request.fields['_method'] = 'PUT';

    // Tambahkan field data profil hanya jika tidak null
    if (name != null) request.fields['name'] = name;
    if (email != null) request.fields['email'] = email;
    if (currentPassword != null) {
      request.fields['current_password'] = currentPassword;
    }
    if (newPassword != null) request.fields['password'] = newPassword;
    if (newPasswordConfirmation != null) {
      request.fields['password_confirmation'] = newPasswordConfirmation;
    }

    // Tambahkan file foto jika ada
    if (foto != null) {
      try {
        request.files.add(
          await http.MultipartFile.fromPath(
            'foto', // Nama field di Laravel untuk foto
            foto.path,
            contentType: MediaType('image', foto.path.split('.').last),
          ),
        );
      } catch (e) {
        // Tangkap error jika gagal memproses file (misalnya path tidak valid)
        throw Exception('Gagal memproses file foto: $e');
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Dekode respons dengan penanganan error yang lebih informatif
    Map<String, dynamic> responseBody;
    try {
      responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      // Cetak respons lengkap untuk debugging (opsional, bisa dihapus di produksi)
      print('Update Profile - Status Code: ${response.statusCode}');
      print('Update Profile - Raw Body: ${response.body}');
      print('Update Profile - Decoded Body: $responseBody');
    } catch (e) {
      throw Exception(
        'Respons API tidak valid atau bukan JSON: $e. Body: ${response.body}',
      );
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Laravel umumnya mengembalikan 200 OK untuk operasi UPDATE yang berhasil.
      return responseBody;
    } else {
      // Ambil pesan error dari respons, atau gunakan pesan default
      final message = responseBody['message'] ?? 'Gagal memperbarui profil';
      final errors =
          responseBody['errors'] ?? {}; // Ambil detail error validasi jika ada
      throw Exception(
        '$message. Status code: ${response.statusCode}. Errors: $errors',
      );
    }
  }

// Fungsi untuk menyimpan data BMI baru
  // Fungsi untuk menyimpan data BMI baru
  static Future<BmiRecord> saveBmiData({
    required double height,
    required double weight,
    required int age,
    required String gender,
    required String activityLevel,
    // Opsional: Kirim juga BMI, BMR, TDEE yang dihitung di frontend
    // Ini bisa membantu backend memverifikasi atau sebagai fallback,
    // tapi backend tetap harus menghitungnya sendiri untuk integritas.
    required double bmi,
    required double bmr,
    required double tdee,
  }) async {
    final token = await _getToken(); // <<< Ambil token di sini
    if (token == null) {
      throw Exception('Authentication token is not set. Please log in.');
    }

    final url = Uri.parse('$baseUrl/bmi');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // Kirim token di header
      },
      body: jsonEncode({
        'height': height,
        'weight': weight,
        'age': age,
        'gender': gender,
        'activity_level': activityLevel,
        // Kirim nilai BMI, BMR, TDEE jika backend mengharapkannya atau untuk verifikasi
        'bmi': bmi,
        'bmr': bmr,
        'tdee': tdee,
      }),
    );

    if (response.statusCode == 201) {
      // 201 Created
      // Pastikan backend Anda mengembalikan data BMI yang baru dibuat di bawah kunci 'data'
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.containsKey('data')) {
        return BmiRecord.fromJson(responseData['data']);
      } else {
        throw Exception('BMI data not found in response: ${response.body}');
      }
    } else {
      // Tangani error dari server (misal, validasi gagal, unauthorized)
      String errorMessage = 'Failed to save BMI data. Status: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        } else if (errorBody.containsKey('errors')) {
          // Jika ada error validasi Laravel
          errorMessage = 'Validation errors: ${errorBody['errors']}';
        }
      } catch (e) {
        // Gagal parse error body, gunakan pesan default
        print('Error parsing error response: $e');
      }
      throw Exception(errorMessage);
    }
  }

  // Fungsi untuk mengambil semua riwayat BMI pengguna
  static Future<List<BmiRecord>> fetchBmiRecords() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Authentication token is not set. Please log in.');
    }

    final url = Uri.parse('$baseUrl/bmi');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body); // <<< PERUBAHAN DI SINI: Ubah tipe menjadi Map

      List<dynamic> bmiListJson;

      // Asumsi backend mengembalikan { "data": [...] }
      if (jsonData.containsKey('data') && jsonData['data'] is List) {
        bmiListJson = jsonData['data'] as List;
      } else {
      
        throw Exception('Format BMI records tidak dikenali atau kunci "data" tidak ditemukan: ${response.body}');
      }

      return bmiListJson.map((json) => BmiRecord.fromJson(json)).toList();
    } else {
      String errorMessage = 'Failed to load BMI records. Status: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        }
      } catch (e) {
        print('Error parsing error response: $e');
      }
      throw Exception(errorMessage);
    }
  }

  // Fungsi untuk mengambil detail satu riwayat BMI
  static Future<BmiRecord> fetchBmiRecord(int id) async {
    final token = await _getToken(); // <<< Ambil token di sini
    if (token == null) {
      throw Exception('Authentication token is not set. Please log in.');
    }

    final url = Uri.parse('$baseUrl/bmi/$id');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Asumsi backend mengembalikan { "data": {...} } untuk detail satu record
      if (data.containsKey('data')) {
        return BmiRecord.fromJson(data['data']);
      } else {
        return BmiRecord.fromJson(data); // Fallback jika respons langsung object
      }
    } else {
      String errorMessage = 'Failed to load BMI record $id. Status: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        }
      } catch (e) {
        print('Error parsing error response: $e');
      }
      throw Exception(errorMessage);
    }
  }
}

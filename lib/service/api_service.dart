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
import 'package:fitly_v1/models/infogizi.dart'; 
import 'package:fitly_v1/models/notification_model.dart';

class ApiService {
  static const String baseUrl =
      'https://8ffb385d73d6.ngrok-free.app/api';
  static const String baseImageUrl =
      'https://8ffb385d73d6.ngrok-free.app/storage/'; // URL dasar untuk gambar
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


 static Future<Article> fetchArticleById(String articleId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Authentication token is not set. Please log in.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/articles/$articleId'), // Sesuaikan dengan endpoint API Anda
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      // Asumsi API mengembalikan objek artikel langsung atau dalam kunci 'data'
      final Map<String, dynamic> articleData = jsonData['data'] ?? jsonData;

      String imageUrl = articleData['image'] != null
          ? baseImageUrl + articleData['image']
          : 'https://placehold.co/200x100/CCCCCC/000000?text=No+Image';

      return Article(
        id: articleData['id'].toString(), // Pastikan ID adalah String
        title: articleData['title'],
        content: articleData['content'],
        image: imageUrl,
      );
    } else if (response.statusCode == 404) {
      throw Exception('Artikel tidak ditemukan dengan ID: $articleId');
    } else {
      String errorMessage = 'Gagal memuat detail artikel. Status: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        }
      } catch (_) {
        // Fallback to default message if error body cannot be parsed
      }
      throw Exception(errorMessage);
    }
  }

  // --- FUNGSI BARU UNTUK MENGAMBIL DETAIL REKOMENDASI BERDASARKAN ID ---
  static Future<Recommendation> fetchRecommendationById(String recommendationId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Authentication token is not set. Please log in.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/recommendations/$recommendationId'), // Sesuaikan dengan endpoint API Anda
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      // Asumsi API mengembalikan objek rekomendasi langsung atau dalam kunci 'data'
      final Map<String, dynamic> recommendationData = jsonData['data'] ?? jsonData;

      return Recommendation.fromJson(recommendationData);
    } else if (response.statusCode == 404) {
      throw Exception('Rekomendasi tidak ditemukan dengan ID: $recommendationId');
    } else {
      String errorMessage = 'Gagal memuat detail rekomendasi. Status: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        }
      } catch (_) {
        // Fallback to default message if error body cannot be parsed
      }
      throw Exception(errorMessage);
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
 // Metode baru untuk memperbarui profil (nama, email, foto)
  static Future<Map<String, dynamic>> updateProfile({
    required String name, // Name is now required for this specific update
    String? email,
    File? foto,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('No token found');

    final uri = Uri.parse('$baseUrl/user/profile');
    var request = http.MultipartRequest('POST', uri) // Gunakan POST untuk multipart
      ..headers['Accept'] = 'application/json'
      ..headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = name; // Name selalu dikirim

    if (email != null) {
      request.fields['email'] = email;
    }
    if (foto != null) {
      request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(responseBody);
    } else {
      final errorData = json.decode(responseBody);
      throw Exception(errorData['message'] ?? 'Gagal memperbarui profil');
    }
  }

  // Metode baru untuk mengubah password
  static Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('No token found');

    final uri = Uri.parse('$baseUrl/user/password');
    final response = await http.put( // Menggunakan PUT
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      final errorData = json.decode(response.body);
      // Laravel validator errors will be in errorData['errors']
      if (errorData['errors'] != null) {
        // Gabungkan semua pesan error validasi menjadi satu string
        String messages = '';
        errorData['errors'].forEach((key, value) {
          messages += '${value[0]}\n';
        });
        throw Exception(messages.trim()); // Trim untuk menghilangkan newline terakhir
      }
      throw Exception(errorData['message'] ?? 'Gagal mengubah password');
    }
  }

  // Fungsi untuk menyimpan data BMI baru
  static Future<BmiRecord> saveBmiData({
    required double height,
    required double weight,
    required int age,
    required String gender,
    required String activityLevel,
    required double bmi,
    required double bmr,
    required double tdee,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Authentication token is not set. Please log in.');
    }

    final url = Uri.parse('$baseUrl/bmi');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'height': height,
        'weight': weight,
        'age': age,
        'gender': gender,
        'activity_level': activityLevel,
        'bmi': bmi,
        'bmr': bmr,
        'tdee': tdee,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.containsKey('data')) {
        return BmiRecord.fromJson(responseData['data']);
      } else {
        throw Exception('BMI data not found in response: ${response.body}');
      }
    } else {
      String errorMessage = 'Failed to save BMI data. Status: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        } else if (errorBody.containsKey('errors')) {
          errorMessage = 'Validation errors: ${errorBody['errors']}';
        }
      } catch (_) {
        // Fallback to default message if error body cannot be parsed
      }
      throw Exception(errorMessage);
    }
  }

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
      final dynamic jsonData = jsonDecode(response.body);

      // Check if the response is a List directly (as indicated by the error)
      if (jsonData is List) {
        return jsonData.map((json) => BmiRecord.fromJson(json as Map<String, dynamic>)).toList();
      } else if (jsonData is Map<String, dynamic> && jsonData.containsKey('data') && jsonData['data'] is List) {
        // Fallback if backend suddenly starts sending { "data": [...] }
        return (jsonData['data'] as List)
            .map((json) => BmiRecord.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Unexpected BMI records format: ${response.body}');
      }
    } else {
      String errorMessage = 'Failed to load BMI records. Status: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        }
      } catch (_) {
        // Fallback to default message if error body cannot be parsed
      }
      throw Exception(errorMessage);
    }
  }

  static Future<BmiRecord> fetchBmiRecord(int id) async {
    final token = await _getToken();
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
      if (data.containsKey('data')) {
        return BmiRecord.fromJson(data['data']);
      } else {
        return BmiRecord.fromJson(data);
      }
    } else {
      String errorMessage = 'Failed to load BMI record $id. Status: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        }
      } catch (_) {
        // Fallback to default message if error body cannot be parsed
      }
      throw Exception(errorMessage);
    }
  }

  //fungsi menghapus data bmi 
 static Future<void> deleteBmiRecord(String recordId) async {
    final token = await _getToken(); // Ambil token
    if (token == null) {
      throw Exception('Authentication token is not set. Please log in.');
    }

    final response = await http.delete(
    
      Uri.parse('$baseUrl/bmi/$recordId'), // Menggunakan endpoint '/bmi/{id}'
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json', // Tambahkan Accept header
        'Authorization': 'Bearer $token', // Tambahkan Authorization header
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) { // 204 No Content juga umum untuk DELETE sukses
      // Sukses, tidak perlu return apa-apa
    } else {
      String errorMessage = 'Gagal menghapus riwayat BMI. Status: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        }
      } catch (_) {
        // Fallback jika body error tidak bisa di-parse
      }
      throw Exception(errorMessage);
    }
  }

 // --- Fungsi Info Gizi ---

  static Future<List<Infogizi>> fetchAllInfogizi() async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/infogizi'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == true && responseData['data'] is List) {
        List<dynamic> dataList = responseData['data'];
        return dataList.map((json) {
         
          final Map<String, dynamic> modifiedJson = Map.from(json);
          // Jika image null atau kosong, berikan placeholder langsung di sini atau di model
          if (modifiedJson['image'] == null || (modifiedJson['image'] is String && modifiedJson['image'].isEmpty)) {
            modifiedJson['image'] = 'https://placehold.co/200x100/CCCCCC/000000?text=No+Image';
          }

          return Infogizi.fromJson(modifiedJson);
        }).toList();
      } else {
        throw Exception('Failed to load Infogizi: ${responseData['message'] ?? 'Unexpected data format'}');
      }
    } else {
      String errorMessage = 'Failed to load Infogizi. Status Code: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        }
      } catch (_) {
        // Fallback jika body error tidak bisa di-parse
      }
      throw Exception(errorMessage);
    }
  }

  static Future<Infogizi> fetchInfogiziById(int id) async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/infogizi/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == true && responseData['data'] is Map<String, dynamic>) {
        final Map<String, dynamic> infogiziData = responseData['data'];
      
        if (infogiziData['image'] == null || (infogiziData['image'] is String && infogiziData['image'].isEmpty)) {
          infogiziData['image'] = 'https://placehold.co/200x100/CCCCCC/000000?text=No+Image';
        }
        
        return Infogizi.fromJson(infogiziData);
      } else {
        throw Exception('Failed to load Infogizi details: ${responseData['message'] ?? 'Unexpected data format'}');
      }
    } else {
      String errorMessage = 'Failed to load Infogizi details. Status Code: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        }
      } catch (_) {
        // Fallback jika body error tidak bisa di-parse
      }
      throw Exception(errorMessage);
    }
  }

  // --- Fungsi Notifikasi yang Diperbarui (setelah digabung) ---

  // Mengambil daftar semua notifikasi pengguna
  static Future<List<AppNotification>> fetchNotifications() async {
    final headers = await getHeaders();
    if (headers['Authorization'] == null) {
      throw Exception('Authentication token is not set. Please log in.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/notifications'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['success'] == true && responseData['data'] is List) {
        List<dynamic> data = responseData['data'];
        return data.map((json) => AppNotification.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load notifications: ${responseData['message'] ?? 'Unexpected data format'}');
      }
    } else if (response.statusCode == 401) {
      throw Exception(
          'Unauthorized: Sesi Anda telah berakhir. Mohon login kembali.');
    } else {
      String errorMessage =
          'Failed to load notifications. Status: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        }
      } catch (_) {
        // Fallback to default message
      }
      throw Exception(errorMessage);
    }
  }

  // Menandai satu notifikasi sebagai sudah dibaca
  static Future<void> markNotificationAsRead(String notificationId) async {
    final headers = await getHeaders();
    if (headers['Authorization'] == null) {
      throw Exception('Authentication token is not set. Please log in.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/notifications/$notificationId/mark-as-read'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['success'] != true) {
        throw Exception(
            responseData['message'] ?? 'Failed to mark notification as read.');
      }
    } else if (response.statusCode == 401) {
      throw Exception(
          'Unauthorized: Sesi Anda telah berakhir. Mohon login kembali.');
    } else {
      String errorMessage =
          'Failed to mark notification as read. Status: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        }
      } catch (_) {
        // Fallback to default message
      }
      throw Exception(errorMessage);
    }
  }

  // Menandai SEMUA notifikasi sebagai sudah dibaca
  static Future<void> markAllNotificationsAsRead() async {
    final headers = await getHeaders();
    if (headers['Authorization'] == null) {
      throw Exception('Authentication token is not set. Please log in.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/notifications/mark-all-as-read'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['success'] != true) {
        throw Exception(responseData['message'] ??
            'Failed to mark all notifications as read.');
      }
    } else if (response.statusCode == 401) {
      throw Exception(
          'Unauthorized: Sesi Anda telah berakhir. Mohon login kembali.');
    } else {
      String errorMessage =
          'Failed to mark all notifications as read. Status: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        }
      } catch (_) {
        // Fallback to default message
      }
      throw Exception(errorMessage);
    }
  }

  // Mengambil jumlah notifikasi yang belum dibaca
  static Future<int> getUnreadNotificationCount() async {
    final headers = await getHeaders();
    if (headers['Authorization'] == null) {
      // Jika tidak ada token, anggap tidak ada notifikasi yang belum dibaca
      return 0;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/notifications/unread-count'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['success'] == true && responseData.containsKey('count')) {
        return responseData['count'] as int;
      } else {
        throw Exception(
            'Failed to get unread count: ${responseData['message'] ?? 'Unexpected data format'}');
      }
    } else if (response.statusCode == 401) {
      // Jika unauthorized, anggap tidak ada notifikasi yang belum dibaca atau token invalid
      return 0;
    } else {
      String errorMessage =
          'Failed to get unread count. Status: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        }
      } catch (_) {
        // Fallback to default message
      }
      throw Exception(errorMessage);
    }
  }
   // Fungsi baru: Menghapus notifikasi berdasarkan ID
  static Future<void> deleteNotification(String notificationId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Authentication token is not set. Please log in.');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/notifications/$notificationId'), // Pastikan ini sesuai dengan endpoint DELETE di Laravel Anda
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) { // 200 OK atau 204 No Content biasanya untuk DELETE
      
      print('Notifikasi dengan ID $notificationId berhasil dihapus dari backend.');
    } else {
      String errorMessage = 'Gagal menghapus notifikasi di backend. Status: ${response.statusCode}';
      try {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'];
        }
      } catch (_) {
       
      }
      print('Error deleting notification: $errorMessage. Response body: ${response.body}');
      throw Exception(errorMessage);
    }
  }
}
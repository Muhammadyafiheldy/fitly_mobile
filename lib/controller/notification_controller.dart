import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart'; // Jika tidak digunakan, bisa dihapus

class NotificationController extends ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final String _baseUrl = 'https://ec68-103-165-150-81.ngrok-free.app/api';
  String _token; // Tidak lagi 'final' karena akan diupdate oleh setter

  // Fungsi: Konstruktor untuk menerima token awal
  NotificationController(this._token);

  // FUNGSI BARU: Setter untuk mengupdate token (dipanggil oleh ProxyProvider)
  set authToken(String token) { 
    if (_token != token) {
      _token = token;
    
      notifyListeners(); // Beri tahu pendengar jika ada perubahan token yang mungkin memengaruhi UI
    }
  }

  // Fungsi: Menambahkan notifikasi baru dari push notification (real-time)
  void addNotificationFromPush({
    required String id,
    required String type,
    required String title,
    required String subtitle,
    String? articleId,
    String? recommendationId,
  }) {
    if (_notifications.any((notif) => notif['id'].toString() == id)) {
      debugPrint('Notifikasi dengan ID $id sudah ada, tidak ditambahkan.');
      return;
    }

    _notifications.insert(0, {
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'time': 'Baru saja',
      'article_id': articleId,
      'recommendation_id': recommendationId,
      'is_read': false,
    });
    notifyListeners();
  }

  // Fungsi: Mengambil notifikasi dari backend
  Future<void> fetchNotificationsFromBackend() async {
    // Pastikan token sudah ada sebelum melakukan fetch
    if (_token.isEmpty) {
      _errorMessage = 'Autentikasi diperlukan untuk mengambil notifikasi.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/notifications'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token', // Gunakan token autentikasi
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          List<dynamic> data = responseData['data'];
          _notifications = data.map<Map<String, dynamic>>((item) {
            return {
              'id': item['id'],
              'type': item['type'],
              'title': item['title'],
              'subtitle': item['subtitle'],
              'time': item['time'],
              'article_id': item['article_id'],
              'recommendation_id': item['recommendation_id'],
              'is_read': item['is_read'],
            };
          }).toList();
        } else {
          _errorMessage = responseData['message'] ?? 'Gagal mengambil notifikasi.';
        }
      } else if (response.statusCode == 401) { // Unauthorized
        _errorMessage = 'Sesi Anda telah berakhir. Mohon login kembali.';
      } else {
        _errorMessage = 'Error ${response.statusCode}: Gagal mengambil notifikasi.';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan jaringan: $e';
      debugPrint('Error fetching notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi: Menandai notifikasi sudah dibaca
  Future<void> markAsRead(String notificationId) async {
    // Pastikan token sudah ada sebelum melakukan aksi
    if (_token.isEmpty) {
      debugPrint('Tidak ada token autentikasi untuk menandai notifikasi.');
      return;
    }

    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/notifications/$notificationId/read'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final index = _notifications.indexWhere((notif) => notif['id'].toString() == notificationId);
        if (index != -1) {
          _notifications[index]['is_read'] = true; // Update status di lokal
          notifyListeners();
        }
      } else {
        debugPrint('Gagal menandai notifikasi dibaca: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error menandai notifikasi dibaca: $e');
    }
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}
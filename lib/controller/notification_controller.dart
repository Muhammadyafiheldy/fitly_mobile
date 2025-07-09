import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fitly_v1/models/notification_model.dart'; // Import model AppNotification
import 'package:fitly_v1/service/api_service.dart'; // Import ApiService

class NotificationController extends ChangeNotifier {
  List<AppNotification> _notifications = []; // Menggunakan AppNotification model
  bool _isLoading = false;
  String? _errorMessage;
  int _unreadCount = 0; // Tambahkan untuk menyimpan jumlah notifikasi belum dibaca

  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _unreadCount; // Getter untuk unreadCount

  // Tidak lagi perlu _baseUrl dan _token di sini karena akan dihandle oleh ApiService
  // String _token; 

  // Constructor yang tidak lagi menerima token, karena ApiService yang akan mengelola token
  NotificationController();

 
  // Fungsi: Menambahkan notifikasi baru dari push notification (real-time) - jika nanti ada FCM
  void addNotificationFromPush({
    required String id,
    required String type,
    required String title,
    required String subtitle,
    String? relatedId, // Diubah
    String? relatedType, // Diubah
  }) {
    if (_notifications.any((notif) => notif.id == id)) {
      debugPrint('Notifikasi dengan ID $id sudah ada, tidak ditambahkan.');
      return;
    }

    _notifications.insert(0, AppNotification( // Menggunakan AppNotification model
      id: id,
      type: type,
      title: title,
      subtitle: subtitle,
      time: 'Baru saja', // Sesuaikan jika ada format waktu real-time yang berbeda
      relatedId: relatedId,
      relatedType: relatedType,
      isRead: false,
    ));
    _unreadCount++; // Tambah jumlah belum dibaca
    notifyListeners();
  }

  // Fungsi: Mengambil notifikasi dari backend
  Future<void> fetchNotificationsFromBackend() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final responseData = await ApiService.getNotifications(); // Panggil fungsi di ApiService

      _notifications = responseData; // Langsung set list notifikasi
      _unreadCount = _notifications.where((notif) => !notif.isRead).length; // Hitung yang belum dibaca
      
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      debugPrint('Error fetching notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi: Menandai notifikasi sudah dibaca
  Future<void> markAsRead(String notificationId) async {
    try {
      await ApiService.markNotificationAsRead(notificationId); // Panggil fungsi di ApiService

      final index = _notifications.indexWhere((notif) => notif.id == notificationId);
      if (index != -1 && !_notifications[index].isRead) {
        _notifications[index] = _notifications[index].copyWith(isRead: true); // Update status di lokal
        _unreadCount--; // Kurangi jumlah belum dibaca
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error menandai notifikasi dibaca: $e');
      // Anda bisa menambahkan _errorMessage di sini jika ingin menampilkan error ke user
    }
  }

  // Fungsi: Mengambil jumlah notifikasi yang belum dibaca
  Future<void> fetchUnreadCount() async {
    try {
      _unreadCount = await ApiService.getUnreadNotificationCount();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching unread count: $e');
      // Tidak perlu set error message ke UI utama, ini adalah background task
    }
  }

  void clearNotifications() {
    _notifications.clear();
    _unreadCount = 0; // Reset count
    notifyListeners();
  }
}
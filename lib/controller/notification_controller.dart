// lib/controller/notification_controller.dart

import 'package:flutter/material.dart';
import 'package:fitly_v1/models/notification_model.dart';
import 'package:fitly_v1/service/api_service.dart';

class NotificationController extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _unreadCount = 0;

  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get unreadCount => _unreadCount;

  NotificationController();

  void addNotificationFromPush({
    required String id,
    required String type,
    required String title,
    required String subtitle,
    String? relatedId,
    String? relatedType,
  }) {
    if (_notifications.any((notif) => notif.id == id)) {
      debugPrint('Notifikasi dengan ID $id sudah ada, tidak ditambahkan.');
      return;
    }

    _notifications.insert(0, AppNotification(
      id: id,
      type: type,
      title: title,
      subtitle: subtitle,
      time: 'Baru saja',
      relatedId: relatedId,
      relatedType: relatedType,
      isRead: false,
    ));
    _unreadCount++;
    notifyListeners();
  }

  Future<void> fetchNotificationsFromBackend() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final responseData = await ApiService.fetchNotifications();
      _notifications = responseData;
      _unreadCount = _notifications.where((notif) => !notif.isRead).length;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      debugPrint('Error fetching notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await ApiService.markNotificationAsRead(notificationId);
      final index = _notifications.indexWhere((notif) => notif.id == notificationId);
      if (index != -1 && !_notifications[index].isRead) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        _unreadCount--;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error menandai notifikasi dibaca: $e');
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      _unreadCount = await ApiService.getUnreadNotificationCount();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching unread count: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await ApiService.markAllNotificationsAsRead();
      _notifications = _notifications.map((notif) => notif.copyWith(isRead: true)).toList();
      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      debugPrint('Error menandai semua notifikasi dibaca: $e');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final initialLength = _notifications.length;
      final int initialUnreadCount = _unreadCount;

      final notifToDelete = _notifications.firstWhereOrNull((notif) => notif.id == notificationId);

      await ApiService.deleteNotification(notificationId);
      
      _notifications.removeWhere((notif) => notif.id == notificationId);

      if (notifToDelete != null && !notifToDelete.isRead) {
        _unreadCount--;
      }
      
      if (_unreadCount < 0) _unreadCount = 0;

      if (_notifications.length != initialLength || _unreadCount != initialUnreadCount) {
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error menghapus notifikasi: $e');
      _errorMessage = 'Gagal menghapus notifikasi: $e';
      notifyListeners();
    }
  }

  void clearNotifications() {
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
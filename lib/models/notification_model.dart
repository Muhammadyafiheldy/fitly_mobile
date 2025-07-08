import 'package:flutter/foundation.dart'; // Untuk @required atau @visibleForTesting jika diperlukan, tapi tidak wajib untuk dasar

class AppNotification {
  final String id;
  final String type; // Contoh: 'new_article', 'new_recommendation', 'general'
  final String title;
  final String subtitle;
  final String time; // Waktu notifikasi, bisa 'Baru saja' atau format tanggal
  final String? articleId; // ID artikel terkait, nullable
  final String? recommendationId; // ID rekomendasi terkait, nullable
  final bool isRead; // Status sudah dibaca atau belum

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
    this.articleId,
    this.recommendationId,
    required this.isRead,
  });

  // Factory constructor untuk membuat instance AppNotification dari JSON (data dari API Laravel)
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'].toString(), // Pastikan ID diolah sebagai String
      type: json['type'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      time: json['time'] as String, // Asumsi 'time' sudah diformat di backend
      articleId: json['article_id']?.toString(), // Handle jika null
      recommendationId: json['recommendation_id']?.toString(), // Handle jika null
      isRead: json['is_read'] as bool,
    );
  }

  // Method untuk mengonversi instance AppNotification ke JSON (misal jika ingin kirim balik ke API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'time': time,
      'article_id': articleId,
      'recommendation_id': recommendationId,
      'is_read': isRead,
    };
  }

  // Method untuk membuat copy dari notifikasi dengan beberapa properti yang diubah
  AppNotification copyWith({
    String? id,
    String? type,
    String? title,
    String? subtitle,
    String? time,
    String? articleId,
    String? recommendationId,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      time: time ?? this.time,
      articleId: articleId ?? this.articleId,
      recommendationId: recommendationId ?? this.recommendationId,
      isRead: isRead ?? this.isRead,
    );
  }
}
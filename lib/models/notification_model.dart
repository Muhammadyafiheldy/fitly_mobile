// lib/models/notification_model.dart

import 'package:flutter/foundation.dart';

class AppNotification {
  final String id;
  final String type; // Contoh: 'new_article', 'new_recommendation', 'general'
  final String title;
  final String subtitle;
  final String time; // Waktu notifikasi, bisa 'Baru saja' atau format tanggal
  final String? relatedId; // ID item terkait (artikel/rekomendasi), nullable
  final String? relatedType; // Tipe item terkait ('article', 'recommendation'), nullable
  final bool isRead; // Status sudah dibaca atau belum

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
    this.relatedId,
    this.relatedType,
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
      relatedId: json['related_id']?.toString(), // Mengambil related_id, bisa null
      relatedType: json['related_type'] as String?, // Mengambil related_type, bisa null
      isRead: json['is_read'] as bool, // Mengambil is_read sebagai boolean
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
      'related_id': relatedId,
      'related_type': relatedType,
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
    String? relatedId,
    String? relatedType,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      time: time ?? this.time,
      relatedId: relatedId ?? this.relatedId,
      relatedType: relatedType ?? this.relatedType,
      isRead: isRead ?? this.isRead,
    );
  }
}
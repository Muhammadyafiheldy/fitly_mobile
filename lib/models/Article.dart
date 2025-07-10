import 'package:flutter/material.dart';

class Article {
  final dynamic id; // Mengubah tipe data id menjadi dynamic
  final String title;
  final String content;
  final String image; // Menambahkan properti image

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.image, // Membutuhkan image saat inisialisasi
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'] ?? '', // Parsing image dari JSON, fallback ke string kosong jika null
    );
  }
}